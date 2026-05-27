---@class Copilot.Status
---@field busy boolean
---@field message string
---@field kind "Normal"|"Error"|"Warning"|"Inactive",
---@field command string?

---@class Copilot.SignIn.Response
---@field userCode string code the user should copy
---@field command lsp.Command
---@field status string? could be AlreadySignedIn

---@class Copilot.NextEdits
---@field edits Copilot.Edit[]
---@class Copilot.Edit
---@field text string
---@field textDocument lsp.VersionedTextDocumentIdentifier
---@field range lsp.Range
---@field command lsp.Command

local M = {}
local fn = require("dark-config.lib.functions")
local extmark_ns = vim.api.nvim_create_namespace("copilot_inline_completion")
---@type table<integer, Copilot.NextEdits>
local current_next_edit = {}

fn.require_binary("copilot-language-server", "Copilot")

vim.lsp.enable("copilot")

---@param status Copilot.Status
vim.lsp.handlers["didChangeStatus"] = function(_, status, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not client or client.name ~= "copilot" then return end

    if status.kind == "Error" then
        vim.notify(
            status.message,
            vim.log.levels.ERROR,
            { title = "Github Copilot" }
        )

        if status.message:match("sign") then
            vim.notify(
                "Use :LspCopilotSignIn to sign in",
                vim.log.levels.INFO,
                { title = "Github Copilot" }
            )
        end
    end
end

---(@type lsp.Handler)
---@param err lsp.ResponseError?
---@param result Copilot.NextEdits
---@param ctx lsp.HandlerContext
local function handle_inline_edit(err, result, ctx)
    if err then
        vim.notify("Error requesting inline edit: " .. err.message, vim.log.levels.ERROR, { title = "Github Copilot" })
        return
    end

    local bufnr = ctx.bufnr
    if bufnr == nil or not vim.api.nvim_buf_is_valid(bufnr) then
        -- closed while request was underway i guess
        return
    end

    M.clear_next_edit(bufnr)

    ---@type lsp.TextDocumentPositionParams
    local params = ctx.params

    if result.edits == nil or #result.edits == 0 then
        vim.api.nvim_buf_set_extmark(bufnr, extmark_ns, params.position.line, params.position.character, {
            virt_text = { { "  No next edit", "Comment" } },
        })
        return
    end

    current_next_edit[bufnr] = result

    local ctrl = require("which-key.config").icons.keys.C
    local shift = require("which-key.config").icons.keys.S
    local letter = "J"
    local bind = ctrl .. shift .. letter
    local accept = bind .. " Accept"

    for _, edit in ipairs(result.edits) do
        local range_start = edit.range["start"]
        local range_end = edit.range["end"]

        vim.api.nvim_buf_set_extmark(bufnr, extmark_ns, range_start.line, 0, {
            end_row = range_end.line + 1,
            end_col = 0,
            hl_group = "DiffRemoved",
            hl_eol = true,
        })

        local lines = vim.iter(vim.split(edit.text, "\n"))
            :map(function(line)
                return { { line, "DiffAdded" } }
            end)
            :totable()

        vim.api.nvim_buf_set_extmark(bufnr, extmark_ns, range_end.line, range_end.character, {
            virt_text = { { accept, "@diff.delta" } },
            virt_lines = lines,
        })
    end
end

---@return vim.lsp.Client?
local function get_copilot(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local copilot = vim.lsp.get_clients { name = "copilot", bufnr = bufnr }[1]
    if not copilot then
        vim.notify("Copilot client not found", vim.log.levels.ERROR)
        return nil
    end
    return copilot
end

---@param bufnr integer?
function M.accept_suggestion(bufnr)
    vim.lsp.inline_completion.get()

    local copilot = get_copilot(bufnr)
    if not copilot then return end

    -- if vim.lsp.inline_completion.get() then
    --     M.request_next_edit(bufnr)
    -- end
end

---@param bufnr integer?
function M.request_or_accept_next_edit(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    if current_next_edit[bufnr] ~= nil then
        M.accept_next_edit(bufnr)
    else
        M.request_next_edit(bufnr)
    end
end

---@param bufnr integer?
function M.request_next_edit(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local copilot = get_copilot(bufnr)
    if not copilot then return end

    local params = vim.lsp.util.make_position_params(0, copilot.offset_encoding)

    ---@diagnostic disable-next-line: inject-field
    params.textDocument.version = vim.lsp.util.buf_versions[vim.api.nvim_get_current_buf()]

    ---@diagnostic disable-next-line: param-type-mismatch (copilotInlineEdit is a custom request method)
    copilot:request("textDocument/copilotInlineEdit", params, handle_inline_edit)

    vim.api.nvim_buf_set_extmark(bufnr, extmark_ns, params.position.line, params.position.character, {
        virt_text = { { "  Requesting next edit...", "Comment" } },
    })
end

---@param bufnr integer?
function M.accept_next_edit(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local next_edit = current_next_edit[bufnr]
    if not next_edit then
        vim.notify("No next edit to accept", vim.log.levels.INFO, { title = "Github Copilot" })
        return
    end

    local copilot = get_copilot(bufnr)

    for _, edit in ipairs(next_edit.edits) do
        local tedit = {
            range = edit.range,
            newText = edit.text,
        }

        local tdedit = {
            textDocument = edit.textDocument,
            edits = {tedit}
        }

        if copilot ~= nil then
            vim.lsp.util.apply_text_document_edit(tdedit, 1, copilot.offset_encoding)
            copilot:exec_cmd(edit.command)
        end
    end

    M.clear_next_edit(bufnr)

    M.request_next_edit(bufnr)
end

---@param bufnr integer?
function M.clear_next_edit(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_clear_namespace(bufnr, extmark_ns, 0, -1)
    current_next_edit[bufnr] = nil
end

vim.api.nvim_create_autocmd({"CursorMoved", "CursorMovedI", "InsertLeave"}, {
    callback = function(args)
        local bufnr = args.buf
        if not vim.api.nvim_buf_is_valid(bufnr) then return end

        M.clear_next_edit(bufnr)
    end,
})

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local bufnr = args.buf
        local copilot = assert(vim.lsp.get_client_by_id(args.data.client_id))

        if not copilot:supports_method("textDocument/inlineCompletion", bufnr) then
            return
        end

        if not copilot.name:match("copilot") then
            vim.notify(
                "LSP client " .. copilot.name .. " supports inline completion but is not Copilot.\n"
                .. "Only Copilot was expected to support this.",
                vim.log.levels.WARN,
                { title = "Github Copilot" }
            )
            return
        end

        vim.lsp.inline_completion.enable(true, { bufnr = bufnr })

        ---@diagnostic disable-next-line: param-type-mismatch
        if not copilot:supports_method("textDocument/copilotInlineEdit", bufnr) then
            vim.notify(
                "Copilot client does not support textDocument/copilotInlineEdit.\n"
                .. "Next edit functionality will be unavailable.",
                vim.log.levels.WARN,
                { title = "Github Copilot" }
            )
        end
    end
})

return M
