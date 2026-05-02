local function github(repo) return "https://github.com/" .. repo end

-- basic plugins that are also installed for root
-- pinned to commit for added security
vim.pack.add {
    {
        -- provides :%S (case-aware substitution)
        src = github "tpope/vim-abolish",
        version = "dcbfe065297d31823561ba787f51056c147aa682",
    },
    {
        -- ga with unicode and digraph info
        src = github "tpope/vim-characterize",
        version = "a8bffac6cead6b2869d939ecad06312b187a4c79",
    },
    {
        -- if/fi, for/done, etc. auto-closing for sh, ruby
        src = github "tpope/vim-endwise",
        version = "4994afb0cdf956d9a665a14b9c834869e602c396",
    },
    {
        -- more support for .
        src = github "tpope/vim-repeat",
        version = "65846025c15494983dafe5e3b46c8f88ab2e9635",
    },
    {
        -- some emacs bindings for insert mode (eg. ^A and ^E)
        src = github "tpope/vim-rsi",
        version = "45540637ead22f011e8215f1c90142e49d946a54",
    },
    {
        -- ^A and ^X for dates and times
        src = github "tpope/vim-speeddating",
        version = "c17eb01ebf5aaf766c53bab1f6592710e5ffb796",
    },
    {
        -- surround operations
        src = github "tpope/vim-surround",
        version = "3d188ed2113431cf8dac77be61b842acb64433d9",
    },
    {
        -- table-like aligning
        src = github "godlygeek/tabular",
        version = "12437cd1b53488e24936ec4b091c9324cafee311",
    },
    {
        -- color scheme
        src = github "shatur/neovim-ayu",
        version = "e5a9f0fa2918d6b5f57c21b3ac014314ee5e41c8",
    },
}

if vim.env.USER ~= "root" then
    vim.pack.add {
        github "muniftanjim/nui.nvim",
        github "nvim-lua/plenary.nvim",
        github "nvim-neo-tree/neo-tree.nvim",
        github "github/copilot.vim",

        -- lsp
        github "neovim/nvim-lspconfig",
    }
end


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
