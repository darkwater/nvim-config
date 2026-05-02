local function github(repo) return "https://github.com/" .. repo end

-- basic plugins that are also installed for root
-- pinned to commit for added security
vim.pack.add {
    -- provides :%S (case-aware substitution)
    { version = "dcbfe065297d31823561ba787f51056c147aa682", src = github "tpope/vim-abolish" },
    -- ga with unicode and digraph info
    { version = "a8bffac6cead6b2869d939ecad06312b187a4c79", src = github "tpope/vim-characterize" },
    -- if/fi, for/done, etc. auto-closing for sh,  ruby
    { version = "4994afb0cdf956d9a665a14b9c834869e602c396", src = github "tpope/vim-endwise" },
    -- more support for .
    { version = "65846025c15494983dafe5e3b46c8f88ab2e9635", src = github "tpope/vim-repeat" },
    -- some emacs bindings for insert mode (eg. ^A and ^E)
    { version = "45540637ead22f011e8215f1c90142e49d946a54", src = github "tpope/vim-rsi" },
    -- ^A and ^X for dates and times
    { version = "c17eb01ebf5aaf766c53bab1f6592710e5ffb796", src = github "tpope/vim-speeddating" },
    -- surround operations
    { version = "3d188ed2113431cf8dac77be61b842acb64433d9", src = github "tpope/vim-surround" },
    -- table-like aligning
    { version = "12437cd1b53488e24936ec4b091c9324cafee311", src = github "godlygeek/tabular" },
    -- color scheme
    { version = "e5a9f0fa2918d6b5f57c21b3ac014314ee5e41c8", src = github "shatur/neovim-ayu" },
    -- shows available keybinds
    { version = "3aab2147e74890957785941f0c1ad87d0a44c15a", src = github "folke/which-key.nvim" },
}

if vim.env.USER ~= "root" then
    vim.pack.add {
        github "github/copilot.vim",
        github "nvim-neo-tree/neo-tree.nvim",
        github "nvim-telescope/telescope.nvim",

        -- lsp
        github "neovim/nvim-lspconfig",

        -- dependencies
        github "muniftanjim/nui.nvim", -- neo-tree
        github "nvim-lua/plenary.nvim", -- neo-tree, telescope
    }
end

--------------------------------------------------------------------------------

-- turn the github links above into hyperlinks :3
-- (chatgpt did this first try)
local ns = vim.api.nvim_create_namespace("github-links")
local function add_github_links(buf)
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

    for lnum, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
        local s, _, repo = line:find('github%s+"([%w_.-]+/[%w_.-]+)"')
        if repo then
            -- find start of the capture inside the match
            local repo_start = line:find(repo, s, true) - 1
            local repo_end = repo_start + #repo

            ---@diagnostic disable-next-line: param-type-mismatch
            vim.api.nvim_buf_set_extmark(buf, ns, lnum - 1, repo_start, {
                end_col = repo_end,
                url = "https://github.com/" .. repo,
                hl_group = "Underlined",
            })
        end
    end
end
vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "TextChangedI" }, {
    pattern = "*/dark-config/plugins.lua",
    callback = function(ev)
        add_github_links(ev.buf)
    end,
})
