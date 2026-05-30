local M = {}

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
        M[key:lower()] = value
    end
end

assert(M.accent_fg_hex, "accent_fg_hex not found in system colors")
assert(M.accent_bg_hex, "accent_bg_hex not found in system colors")

vim.api.nvim_set_hl(0, "SystemColorsAccent", {
    fg = M.accent_fg_hex,
    bg = M.accent_bg_hex,
    bold = true,
})

vim.api.nvim_set_hl(0, "SystemColorsAccentInverted", {
    fg = M.accent_bg_hex,
    bg = M.accent_fg_hex,
    bold = true,
})

return M
