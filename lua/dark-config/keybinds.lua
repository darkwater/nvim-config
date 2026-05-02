vim.keymap.set({"n", "v"}, "<C-s>", "<cmd>write<cr>")
vim.keymap.set({"i", "v"}, "<C-s>", "<esc>:write<cr>")

vim.keymap.set("n", "gg", "gg0")
vim.keymap.set("n", "G", "G0")

vim.keymap.set("n", "<cr>", "<cmd>e #<cr>")

