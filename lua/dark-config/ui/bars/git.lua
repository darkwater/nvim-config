local M = {}

local current_branch
local ahead, behind

function M.cwd_is_git()
    return current_branch ~= nil
end

function M.current_branch()
    return current_branch
end

function M.sync_status()
    if not ahead or not behind then
        return nil
    end

    if ahead > 0 and behind > 0 then
        return "diverged", "󰓢"
    elseif ahead > 0 then
        return tostring(ahead) .. " ahead", ""
    elseif behind > 0 then
        return tostring(behind) .. " behind", ""
    else
        return "up-to-date", "󰓢"
    end
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

            M.update_sync_status()
        else
            current_branch = nil
        end

        vim.schedule(vim.cmd.redrawstatus)
    end)
end

function M.update_sync_status()
    vim.system({
        "git",
        "rev-list",
        "--left-right",
        "--count",
        "HEAD...@{u}",
    }, {
        timeout = 1000,
    }, function(result)
        if result.code == 0 then
            local counts = vim.split(vim.trim(result.stdout), "\t")
            ahead = tonumber(counts[1])
            behind = tonumber(counts[2])
        else
            ahead = nil
            behind = nil
        end

        vim.schedule(vim.cmd.redrawstatus)
    end)
end

vim.schedule(M.update_branch)
vim.api.nvim_create_autocmd({ "DirChanged", "FocusGained" }, {
    group = vim.api.nvim_create_augroup("dark-config.bars.git", { clear = true }),
    callback = M.update_branch,
})

return M
