local M = {}

local fn     = require("dark-config.lib.functions")
local Bar    = require("dark-config.ui.bars.helper")
local colors = require("dark-config.ui.bars.colors")
local git    = require("dark-config.ui.bars.git")
local lsp    = require("dark-config.ui.bars.lsp")

vim.opt.laststatus = 3
vim.opt.statusline = "%!v:lua.require'dark-config.ui.bars'.statusline()"
vim.opt.winbar = "%!v:lua.require'dark-config.ui.bars'.winbar()"

function M.statusline()
    local out = Bar:new()
    local lsp_clients = vim.lsp.get_clients()

    out:module(colors.accent, vim.fn.hostname())
    out:module(colors.blue, vim.fn.fnamemodify(vim.fn.getcwd(), ":~"))

    if not fn.limited_config() then
        if git.cwd_is_git() then
            out:module(colors.cyan, git.current_branch())
        end
    else
        if vim.uv.getuid() == 0 then
            out:module(colors.red, "root")
        else
            out:module(colors.red, "limited")
        end
    end

    out:spacer()

    for client in vim.iter(lsp_clients):rev() do
        lsp.module(out, client)
    end

    out:pad(2)

    return out:get()
end

function M.winbar()
    local out = Bar:new()
    local bufnr = vim.fn.winbufnr(vim.g.statusline_winid)
    local modified = vim.bo[bufnr].modified
    local filetype = vim.bo[bufnr].filetype
    local fileformat = vim.bo[bufnr].fileformat
    -- local lsp_clients = vim.lsp.get_clients { bufnr = bufnr }

    if vim.b[bufnr].neo_tree_source then
        out:module(colors.blue, vim.b[bufnr].neo_tree_source)
        return out:get()
    end

    if modified then
        out:module(colors.orange, "%f •")
    else
        out:module(colors.blue, "%f")
    end

    out:module_opt(colors.red, "%r")

    out:colored_opt(colors.purple, "%a")

    out:spacer()

    -- for _, client in ipairs(lsp_clients) do
    --     lsp.module(out, client)
    -- end

    if fileformat ~= "unix" then
        out:module(colors.red, fileformat)
    end

    out:module(colors.blue, filetype)
    out:module(colors.constant, "%c%Vc")
    out:module(colors.constant, "%l/%Ll")
    out:module(colors.constant, "%p%%")

    return out:get()
end

return M
