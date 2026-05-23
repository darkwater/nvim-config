local M = {}

function M.demo(opts)
    opts = opts or {}

    local path = opts.path or ".tmp/demo-new.png"
    local delay_ms = opts.delay_ms or 1500

    vim.opt.laststatus = 3
    vim.opt.showmode = false
    vim.opt.cmdheight = 1
    vim.opt.termguicolors = true

    vim.cmd("edit README.md")

    pcall(vim.cmd.Neotree, "reveal", "left")

    vim.cmd("wincmd p")
    vim.cmd("normal! gg")

    vim.defer_fn(function()
        vim.notify("dark-config demo loaded", vim.log.levels.INFO, {
            title = "Screenshot demo",
        })
    end, 300)

    vim.defer_fn(function()
        if vim.fn.executable("scrot") == 0 then
            print("scrot is not installed, cannot take screenshot", vim.log.levels.ERROR)
            vim.cmd("cquit 2")
            return
        end

        vim.system({ "scrot", path }, { text = true }, function(result)
            vim.schedule(function()
                if result.code ~= 0 then
                    vim.notify("screenshot failed", vim.log.levels.ERROR)
                    vim.cmd("cquit 3")
                    return
                end

                vim.cmd("qa!")
            end)
        end)
    end, delay_ms)
end

return M
