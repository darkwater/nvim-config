local fn = require("dark-config.lib.functions")

local function dir_specific_setup()
    if vim.fn.filereadable("Cargo.toml") == 0 then
        return
    end

    if not fn.require_binary("rustup", "Rust Analyzer") then
        return
    end

    vim.system(
        { "rustup", "which", "rust-analyzer" },
        {
            text = true,
            stderr = function (_, data)
                -- TODO: nice progress display somehow?
                if data ~= nil then
                    print(data)
                end
            end
        },
        vim.schedule_wrap(function (result)
            if result.code ~= 0 then
                vim.notify(
                    "`rustup which rust-analyzer` failed\nrust-analyzer will not be available",
                    vim.log.levels.WARN,
                    { title = "Rust Analyzer" }
                )
                return
            end

            local path = result.stdout:match("^(.-)%s*$")

            if path and path ~= "" then
                vim.lsp.config("rust_analyzer", {
                    cmd = { path },
                })
            else
                vim.notify(
                    "`rust-analyzer` not found\nrust-analyzer will not be available",
                    vim.log.levels.WARN,
                    { title = "Rust Analyzer" }
                )
            end
        end)
    )
end

local augroup = vim.api.nvim_create_augroup("dark-config.lsp.rust", { clear = true })

vim.api.nvim_create_autocmd("DirChanged", {
    group = augroup,
    pattern = "global",
    callback = dir_specific_setup,
})

vim.api.nvim_create_autocmd("VimEnter", {
    group = augroup,
    callback = dir_specific_setup,
})

vim.api.nvim_create_autocmd('LspAttach', {
    group = augroup,
    callback = function(ev)
        local client_id = ev.data.client_id
        local client = assert(vim.lsp.get_client_by_id(client_id))
        if client.name == 'rust_analyzer' then
            vim.lsp.on_type_formatting.enable(true, { client_id = client_id })
        end
    end,
})

vim.lsp.config("rust_analyzer", {
    settings = {
        ["rust-analyzer"] = {
            assist = { preferSelf = true },
            check = { command = "clippy" },
            completion = { postfix = { enable = false } },
            diagnostics = { enable = false }, -- often has false positives
            imports = { preferNoStd = true },
            inlayHints = {
                bindingModeHints = { enable = true },
                closureCaptureHints = { enable = true },
                closureReturnTypeHints = { enable = "always" },
                discriminantHints = { enable = "always" },
                expressionAdjustmentHints = { enable = "always" },
                genericParametersHints = {
                    lifetime = { enable = true },
                    type = { enable = true },
                },
                implicitDrops = { enable = true },
                lifetimeElisionHints = { enable = true },
                rangeExclusiveHints = { enable = true },
                reborrowHints = { enable = "always" },
            },
            interpret = { tests = true },
        },
    },
})

vim.lsp.enable("rust_analyzer")
