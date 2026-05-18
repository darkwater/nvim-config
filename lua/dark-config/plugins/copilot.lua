---@class Copilot.Status
---@field busy boolean
---@field message string
---@field kind "Normal"|"Error"|"Warning"|"Inactive",
---@field command string?

---@class Copilot.SignIn.Response
---@field userCode string code the user should copy
---@field command lsp.Command
---@field status string? could be AlreadySignedIn

local fn = require("dark-config.functions")

fn.require_binary("copilot-language-server", "Copilot")

---@param status Copilot.Status
vim.lsp.handlers["didChangeStatus"] = function(_, status, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not client or client.name ~= "copilot" then return end

    if status.kind == "Error" then
        vim.notify(
            status.message,
            vim.log.levels.ERROR,
            { title = "Github Copilot" }
        )

        if status.message:match("sign") then
            vim.notify(
                "Use :CopilotSignIn to sign in",
                vim.log.levels.INFO,
                { title = "Github Copilot" }
            )
        end
    end
end

vim.api.nvim_create_user_command("CopilotSignIn", function ()
    local clients = vim.lsp.get_clients { name = "copilot" }
    local copilot = clients[1]
    if not copilot then
        vim.notify("Copilot client not found", vim.log.levels.ERROR)
        return
    end

    ---@param result Copilot.SignIn.Response
    ---@diagnostic disable-next-line: param-type-mismatch (signIn is a custom request method)
    copilot:request("signIn", vim.empty_dict(), function(_, result, _)
        if result.status == "AlreadySignedIn" then
            vim.notify(
                "Already signed in.",
                vim.log.levels.INFO,
                { title = "Github Copilot" }
            )
            return
        end

        vim.fn.setreg("+", result.userCode)
        vim.fn.setreg("*", result.userCode)

        vim.notify(
            "Code: " .. result.userCode .. "\n"
            .. "Copied to clipboard.\n"
            .. "Opening browser in 2 seconds...",
            vim.log.levels.INFO,
            { title = "Github Copilot" }
        )

        vim.defer_fn(function()
            copilot:exec_cmd(result.command, {}, vim.print)
        end, 2000)
    end)
end, {
    desc = "Sign in to the Copilot LSP",
})

vim.lsp.enable("copilot")

  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local bufnr = args.buf
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

      if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, bufnr) then
        vim.lsp.inline_completion.enable(true, { bufnr = bufnr })

        vim.keymap.set(
          'i',
          '<C-F>',
          vim.lsp.inline_completion.get,
          { desc = 'LSP: accept inline completion', buffer = bufnr }
        )
        vim.keymap.set(
          'i',
          '<C-G>',
          vim.lsp.inline_completion.select,
          { desc = 'LSP: switch inline completion', buffer = bufnr }
        )
      end
    end
  })
