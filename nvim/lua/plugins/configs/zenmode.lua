local options = {
    window = {
        backdrop = 0.95,
        width = 80,
    },
    plugins = {
        options = {
            enabled = true,
            ruler = false,
            showcmd = false,
            laststatus = 0,
        },
        tmux = {
            enabled = true
        }, -- disables the tmux statusline
        alacritty = {
            enabled = true,
            font = "14", -- font size
        },
    },
}

return options
