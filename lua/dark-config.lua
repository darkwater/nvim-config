local M = {}

---@class dark-config.opts
---@field only_for_sudo_user string? when invoked with sudo, only set up for this user of sudo

---@param opts dark-config.opts?
---@return boolean applied whether the config was applied or not
function M.setup(opts)
    local fn = require("dark-config.lib.functions")
    if not fn.unlimited_config() and
        opts ~= nil and
        opts.only_for_sudo_user ~= nil and
        vim.env.SUDO_USER ~= nil and
        vim.env.SUDO_USER ~= opts.only_for_sudo_user then
        return false
    end

    -- set this before plugins load
    vim.g.mapleader = " "

    -- note the order; eg. some stuff depends on plugins being loaded
    require("dark-config.plugins")
    require("dark-config.options")
    require("dark-config.keybinds")
    require("dark-config.colors")
    require("dark-config.system-colors")
    require("dark-config.autocmds")
    require("dark-config.bars")

    if vim.g.neovide then
        require("dark-config.neovide")
    end

    if fn.unlimited_config() then
        require("dark-config.lsp.bash")
        require("dark-config.lsp.lua")
        require("dark-config.lsp.rust")
        require("dark-config.lsp.typescript")
        require("dark-config.lsp.yaml")
        require("dark-config.plugins.snacks")
        require("dark-config.plugins.lsp")
        require("dark-config.plugins.neotree")
        require("dark-config.plugins.satellite")
        require("dark-config.plugins.copilot")
        require("dark-config.plugins.completion")
    end

    return true
end

return M
