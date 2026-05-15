local augroup = vim.api.nvim_create_augroup("dark-config", { clear = true })

-- put :help windows on the right and make them 80 columns wide
vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = "help",
    callback = function()
        if vim.o.columns > 140 then
            vim.cmd.wincmd "L"
            vim.cmd.wincmd "80|"
            vim.wo.winfixwidth = true
        end
    end,
})

-- show help notification on vim.pack.update
vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = "nvim-pack",
    callback = function()
        vim.notify(
            "K to view diffs\n" ..
            "gra for code actions\n" ..
            ":w or ^S to accept\n" ..
            ":q or ^W^Q to cancel",
            vim.log.levels.INFO,
            {
                title = "nvim-pack update",
                timeout = false,
            }
        )
    end,
})
