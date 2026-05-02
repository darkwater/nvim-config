local M = {}

function M.setup()
    -- note the order; eg. some stuff depends on plugins being loaded
    require("dark-config.plugins")
    require("dark-config.options")
    require("dark-config.keybinds")
    require("dark-config.colors")

    if vim.g.neovide then
        require("dark-config.neovide")
    end

    if vim.env.USER ~= "root" then
        require("dark-config.lsp.rust")
        require("dark-config.lsp.lua")
    end

    -----------------------------------

    -- TODO: temp
    function edit()
        vim.cmd [[
            cd ~/.config/nvim
            edit old/init.vim
            vsp lua/dark-config.lua
            help lua-guide
            wincmd L
            wincmd 80|
            set winfixwidth
            wincmd h
            Neotree
            wincmd 2l
            wincmd =
            wincmd 2h
        ]]
    end
end

return M
