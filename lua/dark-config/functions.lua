local M = {}

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
