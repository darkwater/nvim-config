local wk  = require("which-key")
local all = { "n", "i", "c", "v", "o", "t" }
local nv  = { "n", "v" }
local ni  = { "n", "i" }
local vi  = { "i", "v" }
local i   = { "i" }

local fn = require("dark-config.lib.functions")
local dsp = require("dark-config.lib.dispatchers")
local copilot = require("dark-config.ai.copilot")

if not wk.did_setup then
    wk.setup {
        preset = "helix",
        icons = { mappings = false },
        expand = 0,
    }
end

-- NOTE: commas are replaced with \x2c to avoid Tabularize aligning on them

wk.add {
    -- some basic keybinds
    { "<C-s>", "<Cmd>write<CR>",      desc = "Save file",           mode = nv },
    { "<C-s>", "<Esc><Cmd>write<CR>", desc = "Save file",           mode = vi },
    { "gg",    "gg0",                 desc = "Go to start of file", mode = nv },
    { "G",     "G0",                  desc = "Go to end of file",   mode = nv },
    { "<CR>",  "<Cmd>e #<CR>",        desc = "Switch to alternate file" },

    { "'",  dsp.open_terminal,   desc = "Open external terminal" },
    { "gd", dsp.goto_definition, desc = "Go to definition", mode = nv },

    { "<leader>d",  group = "diagnostics" },
    { "<leader>dn", dsp.jump_diagnostic(1),  desc = "Go to next diagnostic" },
    { "<leader>dp", dsp.jump_diagnostic(-1), desc = "Go to previous diagnostic" },

    { "<leader><Tab>",     group = "Tabularize" },
    { "<leader><Tab>=",    ":Tabularize /^[^=]*\\zs=<CR>",        desc = "foo = bar",          mode = nv },
    { "<leader><Tab><",    ":Tabularize /<[-=]<CR>",              desc = "foo <- bar <= quux", mode = nv },
    { "<leader><Tab>>",    ":Tabularize /[-=]><CR>",              desc = "foo -> bar >= quux", mode = nv },
    { '<leader><Tab>"',    ':Tabularize /"<CR>',                  desc = 'foo " bar',          mode = nv },
    { "<leader><Tab>#",    ":Tabularize /#<CR>",                  desc = "foo # bar",          mode = nv },
    { "<leader><Tab>(",    ":Tabularize /(<CR>",                  desc = "foo ( bar",          mode = nv },
    { "<leader><Tab>{",    ":Tabularize /{<CR>",                  desc = "foo { bar",          mode = nv },
    { "<leader><Tab>[",    ":Tabularize /[<CR>",                  desc = "foo [ bar",          mode = nv },
    { "<leader><Tab>|",    ":Tabularize /|<CR>",                  desc = "foo | bar",          mode = nv },
    { "<leader><Tab>-",    ":Tabularize /[^-]\\zs--\\ze[^-]<CR>", desc = "foo -- bar",         mode = nv },
    { "<leader><Tab>:",    ":Tabularize /:\\zs/l0r1<CR>",         desc = "foo: bar",           mode = nv },
    { "<leader><Tab>\x2c", ":Tabularize/\x2c\\zs\\ze/l0r1<CR>",   desc = "foo\x2c bar",        mode = nv },

    { "<leader>P",  group = "plugins" },
    { "<leader>Pu", vim.pack.update,          desc = "Update plugins" },
    { "<leader>Pr", dsp.pack_update_lockfile, desc = "Revert plugins to lockfile" },
    { "<leader>Pc", dsp.pack_clean,           desc = "Remove unused plugins" },

    { "<leader>r",  group = "rust" },
    { "<leader>rr", ":Cargo run<CR>",  desc = "Cargo run" },
    { "<leader>rt", ":Cargo test<CR>", desc = "Cargo test" },

    { "<leader>w",  group = "window",      proxy = "<C-w>" },
}

if vim.g.neovide then
    wk.add {
        { "<C-0>", dsp.neovide_zoom(0),       desc = "Reset zoom", mode = all },
        { "<C-=>", dsp.neovide_zoom(1.1),     desc = "Zoom in",    mode = all },
        { "<C-->", dsp.neovide_zoom(1 / 1.1), desc = "Zoom out",   mode = all },
    }
end

if fn.limited_config() then return end

local telescope = require("telescope.builtin")
local gitsigns  = require("gitsigns")
local git       = require("dark-config.git")

wk.add {
    { "grt", telescope.lsp_type_definitions, desc = "Go to type definition", mode = nv },
    { "grr", telescope.lsp_references,       desc = "Go to references",      mode = nv },

    { "<leader>wt", dsp.open_neotree,         desc = "Open Neotree" },
    { "<leader>wS", dsp.open_neotree_symbols, desc = "Open Neotree (document symbols)" },

    { "<C-f>",   copilot.accept_suggestion,            desc = "Accept suggestion",                   mode = i },
    { "<C-S-f>", copilot.accept_suggestion_first_line, desc = "Accept suggestion (first line only)", mode = i },
    { "<C-S-j>", copilot.request_or_accept_next_edit,  desc = "Request/accept next edit",            mode = ni },

    { "<leader>g",  group = "git" },
    { "<leader>gu", gitsigns.reset_hunk,        desc = "Reset git hunk" },
    { "<leader>gd", git.inline_diff.toggle,     desc = "Reset git hunk" },
    { "[h",         dsp.with(gitsigns.nav_hunk, "prev"),                   desc = "Previous git hunk", mode = nv },
    { "]h",         dsp.with(gitsigns.nav_hunk, "next"),                   desc = "Next git hunk",     mode = nv },

    { "<leader>p",     group = "pickers" },
    { "<leader>pp",    dsp.pickers.projects,                              desc = "Open project..." },
    { "<leader>pf",    telescope.find_files,                              desc = "Open project file..." },
    { "<leader>pr",    telescope.oldfiles,                                desc = "Open recent file..." },
    { "<leader>ph",    dsp.pickers.files_in(fn.xdg_config_path("hypr")),  desc = "Open Hyprland config file..." },
    { "<leader>p\x2c", dsp.pickers.files_in(fn.xdg_config_path("nvim")),  desc = "Open Neovim config file..." },
    { "<leader>p.",    dsp.pickers.files_in(vim.env.HOME .. "/dotfiles"), desc = "Open dotfile..." },
    { "<leader>pG",    dsp.pickers.grep,                                  desc = "Search in project..." },
    { "<leader>pg",    telescope.live_grep,                               desc = "Live search in project..." },
    { "<leader>pd",    telescope.diagnostics,                             desc = "Project diagnostics..." },
    { "<leader>p?",    telescope.help_tags,                               desc = "Search for help tag..." },
    { "<leader>pl",    dsp.pickers.lsp_clients,                           desc = "View LSP clients..." },
    { "<leader>pR",    telescope.reloader,                                desc = "Reload a Lua module..." },

    { "<leader>,,", dsp.reload_config, desc = "Reload config" },
}
