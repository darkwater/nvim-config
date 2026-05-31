local fn = require("dark-config.lib.functions")

if fn.unlimited_config() then
    vim.opt.backup = true
    vim.opt.backupdir = { vim.fn.stdpath("state") .. "/backup//" }
end

-- sign column
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

-- hidden characters
vim.opt.list = true
vim.opt.listchars = {
    tab = "┝━",
    trail = "░",
    extends = ">",
    precedes = "<",
    leadmultispace = "│   ",
}
vim.opt.showbreak = "󱞩 "

-- indent
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.shiftround = true

-- search
vim.opt.smartcase = true
vim.opt.ignorecase = true

-- undo
vim.opt.undofile = fn.unlimited_config()
vim.opt.undolevels = 2000

-- window management
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.mousemodel = "extend"
vim.opt.nrformats = { "hex", "bin", "blank", "alpha" }
