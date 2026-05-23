require("snacks").setup {
    notifier = {
        enabled = true,
        timeout = 5000,
        top_down = false,
        margin = {
            bottom = 2,
            right = 2,
        },
    },
    input = {
        enabled = true,
    },
    picker = {
        ui_select = true,
    },
}
