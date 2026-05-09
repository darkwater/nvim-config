local wk = require("which-key")
local nv = { "n", "v" }
local iv = { "i", "v" }

local fn = require("dark-config.functions")
local dsp = require("dark-config.dispatchers")
local telescope = require("telescope.builtin")

wk.setup {
    preset = "helix",
    icons = { mappings = false },
    expand = 0,
}

-- NOTE: commas are replaced with \x2c to avoid Tabularize aligning on them

wk.add {
    -- some basic keybinds
    { "<C-s>", "<Cmd>write<CR>",      desc = "Save file",           mode = nv },
    { "<C-s>", "<Esc><Cmd>write<CR>", desc = "Save file",           mode = iv },
    { "gg",    "gg0",                 desc = "Go to start of file", mode = nv },
    { "G",     "G0",                  desc = "Go to end of file",   mode = nv },
    { "<CR>",  "<Cmd>e #<CR>",        desc = "Switch to alternate file" },

    { "'",  dsp.open_terminal,   desc = "Open external terminal" },
    { "gd", dsp.goto_definition, desc = "Go to definition", mode = nv },

    -- leader keybinds
    { "<leader><Tab>",     group = "Tabularize" },
    { "<leader><Tab>=",    ":Tabularize /^[^=]*\\zs=<CR>",        desc = "foo = bar",          mode = nv },
    { "<leader><Tab><",    ":Tabularize /<[-=]<CR>",              desc = "foo <- bar <= quux", mode = nv },
    { "<leader><Tab>>",    ":Tabularize /[-=]><CR>",              desc = "foo -> bar >= quux", mode = nv },
    { '<leader><Tab>"',    ':Tabularize /"<CR>',                  desc = 'foo " bar',          mode = nv },
    { "<leader><Tab>#",    ":Tabularize /#<CR>",                  desc = "foo # bar",          mode = nv },
    { "<leader><Tab>(",    ":Tabularize /(<CR>",                  desc = "foo ( bar",          mode = nv },
    { "<leader><Tab>{",    ":Tabularize /{<CR>",                  desc = "foo { bar",          mode = nv },
    { "<leader><Tab>[",    ":Tabularize /[<CR>",                  desc = "foo [ bar",          mode = nv },
    { "<leader><Tab>-",    ":Tabularize /[^-]\\zs--\\ze[^-]<CR>", desc = "foo -- bar",         mode = nv },
    { "<leader><Tab>:",    ":Tabularize /:\\zs/l0r1<CR>",         desc = "foo: bar",           mode = nv },
    { "<leader><Tab>\x2c", ":Tabularize/\x2c\\zs\\ze/l0r1<CR>",   desc = "foo\x2c bar",        mode = nv },

    { "<leader>d",  group = "diagnostics" },
    { "<leader>dn", dsp.jump_diagnostic(1),  desc = "Go to next diagnostic" },
    { "<leader>dp", dsp.jump_diagnostic(-1), desc = "Go to previous diagnostic" },

    { "<leader>w",  group = "window",      proxy = "<C-w>" },
    { "<leader>wt", ":Neotree reveal<CR>", desc = "Open Neotree" },

    { "<leader>p",     group = "pickers" },
    -- { "<leader>pp", telescope.find_files,                            desc = "Open project..." },
    { "<leader>pf",    telescope.find_files,                            desc = "Open file..." },
    { "<leader>ph",    dsp.file_picker_in(fn.xdg_config_path("hypr")),  desc = "Open Hyprland config..." },
    { "<leader>p\x2c", dsp.file_picker_in(fn.xdg_config_path("nvim")),  desc = "Open Neovim config..." },
    { "<leader>p.",    dsp.file_picker_in(vim.env.HOME .. "/dotfiles"), desc = "Open Neovim config..." },
}
