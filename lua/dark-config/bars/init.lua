local M = {}

local Bar = require("dark-config.bars.helper")
local colors = require("dark-config.bars.colors")
local git = require("dark-config.bars.git")
local fn = require("dark-config.lib.functions")

vim.opt.laststatus = 3
vim.opt.statusline = "%!v:lua.require'dark-config.bars'.statusline()"
vim.opt.winbar = "%!v:lua.require'dark-config.bars'.winbar()"

function M.statusline()
    local out = Bar:new()

    out:module(colors.accent, vim.fn.hostname())
    out:module(colors.blue, vim.fn.fnamemodify(vim.fn.getcwd(), ":~"))

    if fn.unlimited_config() then
        if git.cwd_is_git() then
            out:module(colors.green, git.current_branch())
        end
    end

    return out:get()
end

function M.winbar()
    local out = Bar:new()
    local bufnr = vim.fn.winbufnr(vim.g.statusline_winid)
    local modified = vim.bo[bufnr].modified
    local filetype = vim.bo[bufnr].filetype

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

    out:module(colors.blue, filetype)
    out:module(colors.constant, "%l:%c%V/%L")

    return out:get()
end

local augroup = vim.api.nvim_create_augroup("dark-config.bars", { clear = true })

return M
