require("ayu").setup {
    mirage = true,
    terminal = true,
    overrides = function ()
        local colors = require("ayu.colors")
        return {
            Normal = { bg = vim.g.neovide and colors.bg or "NONE" },
            NormalFloat = { bg = "#333844" },
            NonText = { fg = "#404850" },
            ComplHint = { fg = "#8090b0" },
            SignColumn = { bg = "NONE" },
            LineNr = { fg = "#606873" },
            Visual = { bg = "#37486d" },
            WinSeparator = { fg = "#606873", bg = "NONE" },
            WinBar = { fg = colors.fg, bg = colors.selection_bg },
            WinBarNC = { fg = colors.fg_idle, bg = colors.bg },
        }
    end,
}

require("ayu").colorscheme()
