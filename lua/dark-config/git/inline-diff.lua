local M = {}

---@class Gitsigns.Hunk.AddedRemoved
---@field start number Line  number (1-based)
---@field count number Line count
---@field lines string[] Line contents

---@class Gitsigns.Hunk
---@field type "add" | "change" | "delete"
---@field head string Header that appears in the unified diff output, eg. "@@ -1,3 +1,9 @@"
---@field lines string[] Line contents prefixed with either "-" or "+"
---@field removed Gitsigns.Hunk.AddedRemoved
---@field added Gitsigns.Hunk.AddedRemoved

local gitsigns = require("gitsigns")

---@type Map<number, boolean>
local enabled_for_bufnr = {}

local extmark_ns = vim.api.nvim_create_namespace("dark_config_git_inline_diff")

function M.enable(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()

    ---@type Gitsigns.Hunk[]?
    local hunks = gitsigns.get_hunks(bufnr)

    for _, hunk in ipairs(hunks or {}) do
        if hunk.removed.count > 0 then
            vim.api.nvim_buf_set_extmark(bufnr, extmark_ns, hunk.added.start - 1, 0, {
                virt_lines = vim.iter(hunk.removed.lines)
                    :map(function(line)
                        return { { line, "DiffDelete" } }
                    end)
                    :totable(),
                virt_lines_above = true,
            })
        end

        if hunk.added.count > 0 then
            vim.api.nvim_buf_set_extmark(bufnr, extmark_ns, hunk.added.start - 1, 0, {
                end_row = hunk.added.start + hunk.added.count - 1,
                end_col = 0,
                end_right_gravity = true,
                hl_group = "DiffAdd",
                hl_eol = true,
            })
        end
    end

    enabled_for_bufnr[bufnr] = true
end

function M.disable(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_clear_namespace(bufnr, extmark_ns, 0, -1)

    enabled_for_bufnr[bufnr] = nil
end

function M.toggle(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    if enabled_for_bufnr[bufnr] then
        M.disable(bufnr)
    else
        M.enable(bufnr)
    end
end

return M
