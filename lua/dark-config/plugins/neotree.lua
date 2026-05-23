require("neo-tree").setup {
    filesystem = {
        window = {
            mappings = {
                ["<space>"] = "none",
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
