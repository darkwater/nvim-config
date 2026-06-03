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

local system_colors = {}

local path = "/etc/system-colors.conf"
local editor_url = "https://darkwater.github.io/system-color-editor"

---@type string
local file_contents
local file, err = io.open(path, "r")
if file then
    file_contents = file:read("*a")
    file:close()
else
    vim.schedule(function ()
        vim.notify(
            "Failed to read " .. path .. "\n"
            .. "`" .. err .. "`\n"
            .. "Using fallback colors\n"
            .. "See `" .. editor_url .. "`",
            vim.log.levels.WARN,
            { title = "System Colors" }
        )
    end)

    file_contents = [[
        ACCENT_HOSTNAME="unknown"
        ACCENT_FG_HEX="#c8c8c8"
        ACCENT_BG_HEX="#323232"
        ACCENT_FG_RGB="200;200;200"
        ACCENT_BG_RGB="50;50;50"
    ]]
end

local lines = vim.split(file_contents, "\n")
for _, line in ipairs(lines) do
    local key, value = line:match('([A-Z_]+)="(.*)"$')
    if key and value then
        system_colors[key:lower()] = value
    end
end

assert(system_colors.accent_fg_hex, "accent_fg_hex not found in system colors")
assert(system_colors.accent_bg_hex, "accent_bg_hex not found in system colors")

vim.api.nvim_set_hl(0, "SystemColorsAccent", {
    fg = system_colors.accent_fg_hex,
    bg = system_colors.accent_bg_hex,
    bold = true,
})

vim.api.nvim_set_hl(0, "SystemColorsAccentInverted", {
    fg = system_colors.accent_bg_hex,
    bg = system_colors.accent_fg_hex,
    bold = true,
})
