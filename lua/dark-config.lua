function github(repo) return "https://github.com/" .. repo end

-- basic plugins that are also installed for root
-- pinned to commit for added security
vim.pack.add {
    {
        -- provides :%S (case-aware substitution)
        src = github("tpope/vim-abolish"),
        version = "dcbfe065297d31823561ba787f51056c147aa682",
    },
    {
        -- ga with unicode and digraph info
        src = github("tpope/vim-characterize"),
        version = "a8bffac6cead6b2869d939ecad06312b187a4c79",
    },
    {
        -- ga with unicode and digraph info
        src = github("tpope/vim-endwise"),
        version = "4994afb0cdf956d9a665a14b9c834869e602c396",
    },
    {
        -- more support for .
        src = github("tpope/vim-repeat"),
        version = "65846025c15494983dafe5e3b46c8f88ab2e9635",
    },
    {
        -- some emacs bindings for insert mode (eg. ^A and ^E)
        src = github("tpope/vim-rsi"),
        version = "45540637ead22f011e8215f1c90142e49d946a54",
    },
    {
        -- ^A and ^X for dates and times
        src = github("tpope/vim-speeddating"),
        version = "c17eb01ebf5aaf766c53bab1f6592710e5ffb796",
    },
    {
        -- surround operations
        src = github("tpope/vim-surround"),
        version = "3d188ed2113431cf8dac77be61b842acb64433d9",
    },
    {
        -- table-like aligning
        src = github("godlygeek/tabular"),
        version = "12437cd1b53488e24936ec4b091c9324cafee311",
    },
    {
        -- color scheme
        src = github("shatur/neovim-ayu"),
        version = "e5a9f0fa2918d6b5f57c21b3ac014314ee5e41c8",
    },
}

vim.pack.add {
    github("muniftanjim/nui.nvim"),
    github("nvim-lua/plenary.nvim"),
    github("nvim-neo-tree/neo-tree.nvim"),
}

-- indent settings
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

-- window management
vim.o.splitright = true
vim.o.splitbelow = true

vim.cmd.colorscheme("ayu-mirage")
vim.keymap.set({"n", "v"}, "<C-s>", "<cmd>write<cr>")
vim.keymap.set({"i", "v"}, "<C-s>", "<esc>:write<cr>")

function edit()
    vim.cmd [[
        cd ~/.config/nvim
        edit old/init.vim
        vsp init.lua
        help lua-guide
        wincmd L
        wincmd 80|
        set winfixwidth
        wincmd h
        Neotree
        wincmd 2l
        wincmd =
    ]]
end
