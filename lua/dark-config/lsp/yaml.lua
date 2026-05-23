vim.lsp.enable("yamlls")

vim.lsp.config("yamlls", {
    settings = {
        yaml = {
            schemas = {
                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                ["https://json.schemastore.org/github-action.json"] = "/.github/action.{yml,yaml}",
            },
        },
    },
})
