-- functions that return functions for use in keybinds

local M = {}

local fn = require("dark-config.lib.functions")

function M.goto_definition()
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

if fn.unlimited_config() then
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
end

return M
