local M = {}

M.unlimited_config = function()
    return vim.env.USER ~= "root"
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

--- Check if any active LSP client supports a given method
---@param method string LSP method to check for support
---@return boolean true if any client supports the method, false otherwise
M.any_lsp_supports_method = function(method)
    return vim.iter(vim.lsp.get_clients()):any(function(client)
        return client.supports_method(method)
    end)
end

return M
