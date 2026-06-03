require("dark-config.lsp.lang.bash")
require("dark-config.lsp.lang.lua")
require("dark-config.lsp.lang.rust")
require("dark-config.lsp.lang.typescript")
require("dark-config.lsp.lang.yaml")
require("dark-config.lsp.completion")

require("tiny-inline-diagnostic").setup {
    preset = "powerline",
    options = {
        override_open_float = true,
        show_source = {
            enabled = true,
        },
        show_related = {
            enabled = true,
            max_count = 5,
        },
        multilines = {
            enabled = true,
            always_show = true,
        },
    },
}

require("fidget").setup {}

local augroup = vim.api.nvim_create_augroup("dark-config.plugins.lsp", { clear = true })

-- prevent fidget window from being animated
vim.api.nvim_create_autocmd("WinResized", {
    group = augroup,
    callback = function(ev)
        local winid = assert(tonumber(ev.file))
        local bufnr = vim.api.nvim_win_get_buf(winid)
        if vim.bo[bufnr].filetype ~= "fidget" then return end

        vim.g.neovide_position_animation_length = 0
        vim.defer_fn(function()
            vim.g.neovide_position_animation_length = 0.2
        end, 20)
    end,
})
