local M = {}

function M.setup()
    -- set this before plugins load
    vim.g.mapleader = " "

    -- note the order; eg. some stuff depends on plugins being loaded
    require("dark-config.plugins")
    require("dark-config.options")
    require("dark-config.keybinds")
    require("dark-config.colors")
    require("dark-config.autocmds")

    if vim.g.neovide then
        require("dark-config.neovide")
    end

    if vim.env.USER ~= "root" then
        require("dark-config.lsp.rust")
        require("dark-config.lsp.lua")
        require("dark-config.plugins.snacks")
        require("dark-config.plugins.completion")
        require("dark-config.plugins.lsp")
        require("dark-config.plugins.neotree")
        require("dark-config.plugins.satellite")
    end
end

return M
