local M = {}

local current_branch

function M.cwd_is_git()
    return current_branch ~= nil
end

function M.current_branch()
    return current_branch
end

function M.update_branch()
    vim.system({
        "git",
        "rev-parse",
        "--abbrev-ref",
        "HEAD",
    }, {
        timeout = 1000,
    }, function(result)
        if result.code == 0 then
            current_branch = vim.trim(result.stdout)
        else
            current_branch = nil
        end

        vim.schedule(vim.cmd.redrawstatus)
    end)
end

vim.schedule(M.update_branch)
vim.api.nvim_create_autocmd({ "DirChanged" }, {
    group = vim.api.nvim_create_augroup("dark-config.bars.git", { clear = true }),
    callback = M.update_branch,
})

return M
