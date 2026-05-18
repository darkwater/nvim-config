require("tiny-inline-diagnostic").setup {
    preset = "powerline",
    options = {
        override_open_float = true,
        show_source = {
            enabled = true,
        },
        show_related = {
            enabled = true,
            max_count = 5,
        },
        multilines = {
            enabled = true,
            always_show = true,
        },
    },
}
