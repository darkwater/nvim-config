vim.o.guifont = "Hack Nerd Font:h9.0"

vim.g.neovide_opacity                    = 0.92
vim.g.neovide_scroll_animation_length    = 0.12
vim.g.neovide_scroll_animation_far_lines = 500
vim.g.neovide_hide_mouse_when_typing     = true
vim.g.neovide_remember_window_size       = true
vim.g.neovide_cursor_animation_length    = 0.08
vim.g.neovide_cursor_antialiasing        = false
vim.g.neovide_position_animation_length  = 0.2
vim.g.neovide_floating_shadow            = false

vim.keymap.set("n", "<C-S-v>", '"+p')
vim.keymap.set({"i", "c"}, "<C-S-v>", "<C-r>+")

-- TODO: freezes neovide?

-- local function neovide_rpc(method, ...) return vim.rpcrequest(vim.g.neovide_channel_id, method, ...) end
-- local function neovide_copy(lines) return neovide_rpc("neovide.set_clipboard", lines) end
-- local function neovide_paste() return neovide_rpc("neovide.get_clipboard") end
--
-- vim.g.clipboard = {
--     name = "neovide",
--     copy = {
--         ["+"] = neovide_copy,
--         ["*"] = neovide_copy,
--     },
--     paste = {
--         ["+"] = neovide_paste,
--         ["*"] = neovide_paste,
--     },
--     cache_enabled = 0,
-- }
