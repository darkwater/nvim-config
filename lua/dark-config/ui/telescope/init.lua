local M = {
    pickers = {
        lsp_clients = require("dark-config.ui.telescope.lsp-clients"),
        projects = require("dark-config.ui.telescope.projects"),
    },
}

local telescope = require("telescope.builtin")

--- Open Telescope in this directory
---@param dir string directory to pick files in
---@return function
function M.pickers.files_in(dir)
    return function ()
        telescope.find_files { cwd = dir, hidden = true }
    end
end

function M.pickers.grep()
    vim.ui.input({
        prompt = "Grep for",
    }, function(input)
        if not input or input == "" then return end
        telescope.live_grep { default_text = input }
    end)
end

return M
