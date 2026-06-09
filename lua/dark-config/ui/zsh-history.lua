---@type Map<number, Map<number, boolean>>
local visited_lines = {}

local extmark_ns = vim.api.nvim_create_namespace("dark-config.ui.zsh-history")
local augroup = vim.api.nvim_create_augroup("dark-config.ui.zsh-history", { clear = true })

-- convert timestamp in .zsh_history files
vim.api.nvim_create_autocmd("CursorMoved", {
    group = augroup,
    pattern = ".zsh_history",
    callback = function(ev)
        local bufnr = ev.buf
        local line = vim.api.nvim_win_get_cursor(0)[1]

        if visited_lines[bufnr] == nil then
            visited_lines[bufnr] = {}
        end

        if not visited_lines[bufnr][line] then
            visited_lines[bufnr][line] = true

            local line_text = vim.api.nvim_buf_get_lines(bufnr, line - 1, line, false)[1]
            local start_pos, end_pos, timestamp = line_text:find(": (%d+):(%d+);")

            if not timestamp then
                return
            end

            local time = os.date("%Y-%m-%d %Hh", tonumber(timestamp))

            vim.api.nvim_buf_set_extmark(bufnr, extmark_ns, line - 1, start_pos - 1, {
                end_col = end_pos - 1,
                virt_text = { { time, "Comment" } },
                virt_text_pos = "overlay",
            })
        end
    end,
})
