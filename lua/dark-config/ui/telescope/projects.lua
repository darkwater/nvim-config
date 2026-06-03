local ts_pickers = require("telescope.pickers")
local ts_finders = require("telescope.finders")
local ts_previewers = require("telescope.previewers")
local ts_actions = require("telescope.actions")
local ts_actions_state = require("telescope.actions.state")
local ts_conf = require("telescope.config").values

return function(opts)
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
