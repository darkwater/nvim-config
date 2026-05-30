local fn = require("dark-config.lib.functions")

local augroup = vim.api.nvim_create_augroup("dark-config.autocmds", { clear = true })

-- put :help windows on the right and make them 80 columns wide
-- TODO: this only works on the first :help in a session
vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = "help",
    callback = function()
        if vim.o.columns > 140 or vim.o.columns > vim.o.lines then
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

-- format some types of buffers on save
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.rs" },
    callback = function()
        if fn.any_lsp_supports_method("textDocument/formatting") then
            vim.lsp.buf.format()
        end
    end,
})

-- mfw too much rust
vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = "lua",
    callback = function()
        vim.cmd.abbreviate("<buffer>", "let", "local")
    end,
})

-- show lsp activations
vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup,
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        vim.notify(
            "LSP attached: `" .. client.name .. "`",
            vim.log.levels.INFO,
            {
                title = "LSP attached",
                timeout = 1500,
            }
        )
    end,
})

-- update leadmultispace according to shiftwidth
vim.api.nvim_create_autocmd("OptionSet", {
    group = augroup,
    pattern = "shiftwidth",
    callback = function(_)
        local sw = vim.bo.shiftwidth
        vim.opt_local.listchars:append { leadmultispace = "│" .. string.rep(" ", sw - 1) }
    end,
})

-- -- autoreload config files
-- -- TODO: maybe dont keep forever idk
-- vim.api.nvim_create_autocmd("BufWritePost", {
--     group = augroup,
--     pattern = "*.config/nvim/lua/dark-config/*",
--     callback = function(ev)
--         local pos = ev.file:find("/lua/dark%-config")
--         local relative_path = ev.file:sub(pos + #"/lua/")
--         -- dark-config/statusline/init.lua
--
--         local without_ext = relative_path:sub(1, -5)
--         -- dark-config/statusline/init
--
--         local with_dots = without_ext:gsub("/", ".")
--         -- dark-config.statusline.init
--
--         local module_name = with_dots:gsub("%.init$", "")
--         -- dark-config.statusline
--
--         package.loaded[module_name] = nil
--         require(module_name)
--     end,
-- })
