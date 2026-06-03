-- functions that return functions for use in keybinds

local M = {}

local fn = require("dark-config.lib.functions")

--- Wrap a function with arguments
---
--- M.fn(foo, "bar") will return function() foo("bar") end
---
---@param func fun(...) function to wrap
---@param ... any arguments to pass to function
---@return fun() wrapped function
function M.with(func, ...)
    local args = { ... }
    return function()
        func(unpack(args))
    end
end

function M.goto_definition()
    if fn.any_lsp_supports_method("textDocument/definition") then
        if not fn.limited_config() then
            require("telescope.builtin").lsp_definitions()
        else
            vim.lsp.buf.definition()
        end
    else
        vim.cmd("normal! gd")
    end
end

---@param count integer direction to jump in (positive for next, negative for previous)
---@return function
function M.jump_diagnostic(count)
    return function()
        vim.diagnostic.jump { count = count }
    end
end

--- Revert plugins back to versions specified in lockfile
function M.pack_update_lockfile()
    vim.pack.update(nil, { target = "lockfile" })
end

--- Remove inactive plugins from disk
function M.pack_clean()
    local inactive = vim.iter(vim.pack.get())
        :filter(function(p) return not p.active end)
        :map(function(p) return p.spec.name end)
        :totable()

    vim.pack.del(inactive)
end

--- Zoom in or out in Neovide by a factor.
--- Pass 0 to reset zoom.
---@param factor number
function M.neovide_zoom(factor)
    return function()
        if factor == 0 then
            vim.g.neovide_scale_factor = 1.0
            return
        end

        if vim.g.neovide_scale_factor == nil then
            vim.g.neovide_scale_factor = 1.0
        end

        vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * factor
    end
end

--- Reload config
function M.reload_config()
    fn.unload_packages("dark%-config")
    local success, err = pcall(require, "dark-config")
    if success then
        ---@diagnostic disable-next-line: cast-local-type
        success, err = pcall(require("dark-config").setup)
    end
    if not success then
        vim.notify(
            "Error reloading config: " .. err,
            vim.log.levels.ERROR,
            { title = "Config reload failed" }
        )
    else
        vim.notify(
            "Config reloaded successfully",
            vim.log.levels.INFO,
            {
                title = "Config reload",
                timeout = 500,
            }
        )
    end
end

if fn.limited_config() then return M end

function M.open_terminal()
    if vim.env.DISPLAY or vim.env.WAYLAND_DISPLAY then
        vim.system(
            { "kitty", "--directory", vim.fn.getcwd() },
            { detach = true }
        )
    else
        vim.notify(
            "No display env set; won't spawn kitty",
            vim.log.levels.ERROR
        )
    end
end

M.pickers = require("dark-config.ui.telescope").pickers

return M
