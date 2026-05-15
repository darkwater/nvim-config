-- functions that return functions for use in keybinds

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

--- Open Telescope in this directory
---@param dir string directory to pick files in
---@return function
M.file_picker_in = function(dir)
    return function ()
        telescope.find_files { cwd = dir }
    end
end

---@param count integer direction to jump in (positive for next, negative for previous)
---@return function
M.jump_diagnostic = function(count)
    return function()
        vim.diagnostic.jump { count = count }
    end
end

--- Revert plugins back to versions specified in lockfile
M.pack_update_lockfile = function()
    vim.pack.update(nil, { target = "lockfile" })
end

--- Remove inactive plugins from disk
M.pack_clean = function()
    local inactive = vim.iter(vim.pack.get())
        :filter(function(p) return not p.active end)
        :map(function(p) return p.spec.name end)
        :totable()

    vim.pack.del(inactive)
end

return M
