local fn = require("dark-config.lib.functions")

vim.lsp.enable("bashls")

vim.api.nvim_create_autocmd("FileType", {
    pattern = {"bash", "sh"},
    callback = function()
        fn.require_binary("bash-language-server", "Bash LSP")
        fn.require_binary("shellcheck", "Linting")
    end,
})

