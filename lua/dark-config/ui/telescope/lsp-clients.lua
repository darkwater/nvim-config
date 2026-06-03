local ts_pickers = require("telescope.pickers")
local ts_finders = require("telescope.finders")
local ts_previewers = require("telescope.previewers")
local ts_actions = require("telescope.actions")
local ts_actions_state = require("telescope.actions.state")
local ts_conf = require("telescope.config").values

return function(opts)
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
            define_preview = function(self, entry, _)
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
