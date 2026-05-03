-- sign column
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

-- indent settings
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.shiftround = true

-- window management
vim.opt.splitright = true
vim.opt.splitbelow = true

-- put :help windows on the right and make them 80 columns wide
vim.api.nvim_create_autocmd("FileType", {
    pattern = "help",
    callback = function()
        if vim.o.columns > 120 then
            vim.cmd.wincmd "L"
            vim.cmd.wincmd "80|"
            vim.wo.winfixwidth = true
        end
    end,
})
