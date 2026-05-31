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

local telescope = require("telescope.builtin")
local ts_pickers = require("telescope.pickers")
local ts_finders = require("telescope.finders")
local ts_previewers = require("telescope.previewers")
local ts_actions = require("telescope.actions")
local ts_actions_state = require("telescope.actions.state")
local ts_conf = require("telescope.config").values

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

--- Open Telescope in this directory
---@param dir string directory to pick files in
---@return function
function M.file_picker_in(dir)
    return function ()
        telescope.find_files { cwd = dir, hidden = true }
    end
end

function M.grep_picker()
    vim.ui.input({
        prompt = "Grep for",
    }, function(input)
        if not input or input == "" then return end
        telescope.live_grep { default_text = input }
    end)
end

function M.project_picker(opts)
    vim.system(
        { "bash", "-c", "ls -1td ~/git*/*/*/ ~/.config/nvim/" },
        { text = true },
        vim.schedule_wrap(function(res)
            local projects = vim.split(res.stdout, "\n")

            vim.g.neovide_scroll_animation_length = 0
            vim.defer_fn(function()
                vim.g.neovide_scroll_animation_length = 0.12
            end, 100)

            opts = opts or {}
            ts_pickers.new(opts, {
                prompt_title = "Projects",
                finder = ts_finders.new_table {
                    results = projects,
                },
                previewer = ts_previewers.new_termopen_previewer {
                    get_command = function(entry)
                        return { "bash", "-c", "cd " .. entry[1] .. " && git status && git diff" }
                    end,
                    env = {
                        ["PAGER"] = "cat",
                    },
                },
                sorter = ts_conf.file_sorter(opts),
                attach_mappings = function(prompt_bufnr, _)
                    ts_actions.select_default:replace(function()
                        ts_actions.close(prompt_bufnr)
                        local selection = ts_actions_state.get_selected_entry()
                        if selection then
                            vim.cmd.cd(selection[1])
                        end
                    end)
                    return true
                end,
            }):find()
        end)
    )
end

function M.lsp_clients_picker(opts)
    local clients = vim.lsp.get_clients()
    if #clients == 0 then
        vim.notify("No LSP clients attached", vim.log.levels.INFO)
        return
    end

    opts = opts or {}
    ts_pickers.new(opts, {
        prompt_title = "LSP Clients",
        finder = ts_finders.new_table {
            results = clients,
            ---@param client vim.lsp.Client
            entry_maker = function(client)
                return {
                    value = client,
                    display = client.id .. ": " ..
                        (client.server_info
                            and client.server_info.name
                            or client.name),
                    ordinal = client.id,
                }
            end,
        },
        previewer = ts_previewers.new_buffer_previewer {
            define_preview = function(self, entry, status)
                local client = entry.value
                local bufnr = self.state.bufnr
                local winid = self.state.winid

                vim.bo[bufnr].filetype = "lua"
                vim.wo[winid].wrap = true
                vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(vim.inspect(client), "\n"))

                -- vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
                --     "Name: " .. client.name,
                --     "ID: " .. client.id,
                --     "Address: " .. (client.address or "n/a"),
                --     "Port: " .. (client.port or "n/a"),
                --     "Root directory: " .. (client.root_dir or "n/a"),
                --     "Capabilities:",
                -- })
                --
                -- for cap, supported in pairs(client.server_capabilities) do
                --     if supported then
                --         vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "- " .. cap })
                --     end
                -- end
            end,
        },
        sorter = ts_conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, _)
            ts_actions.select_default:replace(function()
                ts_actions.close(prompt_bufnr)
                local selection = ts_actions_state.get_selected_entry()
                if selection then
                    vim.notify("Selected LSP client: " .. selection.value.name, vim.log.levels.INFO)
                end
            end)
            return true
        end,
    }):find()
end

return M
