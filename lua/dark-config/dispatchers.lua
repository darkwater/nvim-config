-- functions that return functions for use in keybinds

local M = {}

local fn = require("dark-config.functions")

M.goto_definition = function()
    if fn.any_lsp_supports_method("textDocument/definition") then
        if fn.unlimited_config() then
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

if fn.unlimited_config() then
    local telescope = require("telescope.builtin")

    M.open_terminal = function()
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

    --- Open Telescope in this directory
    ---@param dir string directory to pick files in
    ---@return function
    M.file_picker_in = function(dir)
        return function ()
            telescope.find_files { cwd = dir }
        end
    end

    M.grep_picker = function()
        vim.ui.input({
            prompt = "Grep for",
        }, function(input)
            if not input or input == "" then return end
            telescope.live_grep { default_text = input }
        end)
    end
end

return M
