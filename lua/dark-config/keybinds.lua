local wk = require("which-key")
local nv = { "n", "v" }
local iv = { "i", "v" }

wk.add {
    -- some basic keybinds
    { "<C-s>", "<Cmd>write<CR>",      desc = "Save file",           mode = nv },
    { "<C-s>", "<Esc><Cmd>write<CR>", desc = "Save file",           mode = iv },
    { "gg",    "gg0",                 desc = "Go to start of file", mode = nv },
    { "G",     "G0",                  desc = "Go to end of file",   mode = nv },
    { "<cr>",  "<Cmd>e #<CR>",        desc = "Switch to alternate file" },

    -- leader keybinds
    { "<leader><Tab>",     group = "Tabularize" },
    { "<leader><Tab>=",    ":Tabularize /^[^=]*\\zs=<CR>",      desc = "foo = bar",          mode = nv },
    { "<leader><Tab><",    ":Tabularize /<[-=]<CR>",            desc = "foo <- bar <= quux", mode = nv },
    { "<leader><Tab>>",    ":Tabularize /[-=]><CR>",            desc = "foo -> bar >= quux", mode = nv },
    { '<leader><Tab>"',    ':Tabularize /"<CR>',                desc = 'foo " bar',          mode = nv },
    { "<leader><Tab>#",    ":Tabularize /#<CR>",                desc = "foo # bar",          mode = nv },
    { "<leader><Tab>(",    ":Tabularize /(<CR>",                desc = "foo ( bar",          mode = nv },
    { "<leader><Tab>{",    ":Tabularize /{<CR>",                desc = "foo { bar",          mode = nv },
    { "<leader><Tab>[",    ":Tabularize /[<CR>",                desc = "foo [ bar",          mode = nv },
    { "<leader><Tab>:",    ":Tabularize /:\\zs/l0r1<CR>",       desc = "foo: bar",           mode = nv },
    { "<leader><Tab>\x2c", ":Tabularize/\x2c\\zs\\ze/l0r1<CR>", desc = "foo\x2c bar",        mode = nv },

    { "<leader>w", proxy = "<C-w>" },

    { "'", function()
        vim.system(
            { "kitty", "--directory", vim.fn.getcwd() },
            { detach = true }
        )
    end, desc = "Toggle terminal" },
}
