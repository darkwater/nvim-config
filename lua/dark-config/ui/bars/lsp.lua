local M = {}

local colors = require("dark-config.ui.bars.colors")

M.icons = {
    copilot = "",
    lua_ls = "",
    rust_analyzer = "",
    yamlls = "",
    clangd = "",
}

---@param client vim.lsp.Client
---@param bufnr integer
function M.is_attached_to(client, bufnr)
    return not not client.attached_buffers[bufnr]
end

---@param client vim.lsp.Client
function M.get_label(client)
    return M.icons[client.name] or client.name
end

---@param out dark-config.bars.Bar
---@param client vim.lsp.Client
---@param bufnr integer? bufnr for winbar, nil for statusline
function M.module(out, client, bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()

    local color
    if M.is_attached_to(client, bufnr) then
        color = colors.green
    else
        color = colors.grey
    end

    out:module(color, M.get_label(client))
end

local augroup = vim.api.nvim_create_augroup("dark-config.bars.lsp", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup,
    callback = function(_)
        vim.cmd.redrawstatus()
    end,
})

-- vim.api.nvim_create_autocmd("LspProgress", {
--     group = augroup,
--     ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
--     callback = function(ev)
--         local value = ev.data.params.value
--         vim.api.nvim_echo({ { value.message or 'done' } }, false, {
--             id = 'lsp.' .. ev.data.params.token,
--             kind = 'progress',
--             source = 'vim.lsp',
--             title = value.title,
--             status = value.kind ~= 'end' and 'running' or 'success',
--             percent = value.percentage,
--         })
--
--         local client = vim.lsp.get_client_by_id(ev.data.client_id)
--         if not client then return end
--         for msg in client.progress do
--             vim.notify(vim.inspect(msg.value), "info", {
--                 id = tostring(msg.token),
--                 title = tostring(msg.token),
--                 timeout = 5000,
--             })
--         end
--     end,
-- })

return M
