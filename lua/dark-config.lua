local M = {}

---@class dark-config.opts
---@field only_for_sudo_user string? when invoked with sudo, only set up for this user of sudo

---@param opts dark-config.opts?
---@return boolean applied whether the config was applied or not
function M.setup(opts)
    local fn = require("dark-config.lib.functions")
    if fn.limited_config() and
        opts ~= nil and
        opts.only_for_sudo_user ~= nil and
        vim.env.SUDO_USER ~= nil and
        vim.env.SUDO_USER ~= opts.only_for_sudo_user then
        return false
    end

    -- set this before plugins load
    vim.g.mapleader = " "

    if vim.g.neovide then
        require("dark-config.neovide")
    end

    -- note the order; eg. some stuff depends on plugins being loaded
    require("dark-config.plugins")
    require("dark-config.options")
    require("dark-config.keybinds")
    require("dark-config.colors")
    require("dark-config.autocmds")
    require("dark-config.ui.bars")

    if not fn.limited_config() then
        require("dark-config.lsp")
        require("dark-config.ui.snacks")
        require("dark-config.ui.neotree")
        require("dark-config.ui.satellite")
        require("dark-config.ui.zsh-history")
        require("dark-config.ai.copilot")
    end

    return true
end

return M
