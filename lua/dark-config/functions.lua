local M = {}

local telescope = require("telescope.builtin")

M.open_terminal = function()
    if vim.env.DISPLAY or vim.env.WAYLAND_DISPLAY then
        vim.system(
            { "kitty", "--directory", vim.fn.getcwd() },
            { detach = true }
        )
    end
end

M.goto_definition = function()
    local lsp_support = vim.iter(vim.lsp.get_clients()):any(function (v)
        return v:supports_method("textDocument/definition")
    end)

    if lsp_support then
        -- vim.lsp.buf.definition()
        telescope.lsp_definitions()
    else
        vim.cmd("normal! gd")
    end
end

--- Dispatcher to open Telescope in this directory
---@param dir string directory to pick files in
---@return function
M.file_picker_in = function(dir)
    return function ()
        telescope.find_files { cwd = dir }
    end
end

--- Return ~/.config/{app} or ~/.config when app is empty
---@param app string? name of the app to get config path for
---@return string path to the config directory
M.xdg_config_path = function(app)
    local config_home = vim.env.XDG_CONFIG_HOME or (vim.env.HOME .. "/.config")
    if app and app ~= "" then
        return config_home .. "/" .. app
    else
        return config_home
    end
end

return M
