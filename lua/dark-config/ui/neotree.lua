require("neo-tree").setup {
    window = {
        width = 30,
    },
    filesystem = {
        window = {
            mappings = {
                ["<space>"] = "none",
            },
        },
        filtered_items = {
            visible = false,
            hide_dotfiles = false,
            always_show = {
                ".cargo",
                ".github",
                ".gitea",
            },
            hide_by_name = {
                "__generated__",
                ".git",
                ".gitmodules",
            },
            hide_by_pattern = {
                "*.g.dart",
                "*.freezed.dart",
            },
        },
    },
    default_component_configs = {
        icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "",
            folder_empty_open = "",
            default = "󰧮",
            use_filtered_colors = true,

            ---@diagnostic disable-next-line: unused-local
            provider = function(config, node, state)
                -- TODO: figure out how to detect symlinks and other special files
                -- config.text = " "
            end,
        },
    },
}
