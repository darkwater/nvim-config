local function dir_specific_setup()
    if vim.fn.executable("rustup") == 0 then
        if vim.fn.filereadable("Cargo.toml") == 1 then
            print("rustup not found, rust-analyzer will not be available")
        end
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
        function (result)
            if result.code ~= 0 then
                print("rustup which rust-analyzer failed with code " .. result.code)
                return
            end

            local path = result.stdout:match("^(.-)%s*$")

            if path and path ~= "" then
                vim.lsp.config("rust_analyzer", {
                    cmd = { path },
                })
            else
                print("rust-analyzer not found, rust-analyzer will not be available")
            end
        end
    )
end

vim.api.nvim_create_autocmd("DirChanged", {
    pattern = "global",
    callback = dir_specific_setup,
})

vim.api.nvim_create_autocmd("VimEnter", {
    callback = dir_specific_setup,
})

vim.lsp.config("rust_analyzer", {
    settings = {
        ["rust-analyzer"] = {
            assist = { preferSelf = true },
            check = { command = "clippy" },
            completion = { postfix = { enable = false } },
            diagnostics = { enable = true }, -- often has false positives
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

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local client_id = ev.data.client_id
        local client = assert(vim.lsp.get_client_by_id(client_id))
        if client.name == 'rust_analyzer' then
            vim.lsp.on_type_formatting.enable(true, { client_id = client_id })
        end
    end,
})
