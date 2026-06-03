local blink = require("blink.cmp")

local function init()
    blink.setup {
        completion = { documentation = { auto_show = true } },
        sources = {
            default = { "lsp", "path", "snippets" },
        },
        fuzzy = {
            implementation = (vim.g.BLINK_DONT_BUILD_FUZZY or vim.g.blink_dont_build_fuzzy_for_now)
                                and "lua" or "rust",
        },
        cmdline = { enabled = false },
    }
end

vim.schedule(function()
    if blink.library_available() or vim.g.BLINK_DONT_BUILD_FUZZY then
        init()
    else
        vim.ui.select(
            { "build now (will block for a while)", "later (use lua impl)", "never build on this machine" },
            { prompt = "Blink's fuzzy library is not available. Build it now? Requires Rust/cargo." },
            function (_, choice)
                if choice == 1 then
                    blink.build():wait(60000)
                    init()
                elseif choice == 2 then
                    vim.notify("Blink will use its Lua implementation for this session.")
                    vim.g.blink_dont_build_fuzzy_for_now = true
                    init()
                elseif choice == 3 then
                    vim.notify("Blink's fuzzy library will not be built. This choice will be remembered " ..
                        "in g:BLINK_DONT_BUILD_FUZZY. Clear this variable to be prompted again.", vim.log.levels.INFO)

                    vim.g.BLINK_DONT_BUILD_FUZZY = true
                    init()
                end
            end
        )
    end
end)
