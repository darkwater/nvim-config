require("ayu").setup {
    mirage = true,
    terminal = true,
    overrides = {
        Normal = { bg = vim.g.neovide and "#1f2430" or "NONE" },
        NormalFloat = { bg = "#333844" },
        SignColumn = { bg = "NONE" },
        LineNr = { fg = "#606873" },
        Visual = { bg = "#37486d" },
        WinSeparator = { fg = "#606873", bg = "NONE" },
    },
}

vim.cmd.colorscheme "ayu"
