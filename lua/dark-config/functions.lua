local M = {}

function M.unlimited_config()
    return vim.uv.getuid() ~= 0
end

--- Return ~/.config/{app} or ~/.config when app is empty
---@param app string? name of the app to get config path for
---@return string path path to the config directory
function M.xdg_config_path(app)
    local config_home = vim.env.XDG_CONFIG_HOME or (vim.env.HOME .. "/.config")
    if app and app ~= "" then
        return config_home .. "/" .. app
    else
        return config_home
    end
end

--- Check if any active LSP client supports a given method
---@param method string LSP method to check for support
---@return boolean supported true if any client supports the method, false otherwise
function M.any_lsp_supports_method(method)
    return vim.iter(vim.lsp.get_clients()):any(function(client)
        return client.supports_method(method)
    end)
end

--- Show a warning if some executable isn't found
---@param binary string name of executable to search for
---@param feature string feature that will be unavailable
---@return boolean exists whether the binary exists
function M.require_binary(binary, feature)
    local exists = vim.fn.executable(binary) == 1

    if not exists then
        vim.notify(
            binary .. " not found",
            vim.log.levels.WARN,
            { title = feature .. " unavailable" }
        )
    end

    return exists
end

return M
