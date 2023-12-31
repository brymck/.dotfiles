require("cloak").setup({
    enabled = true,
    cloak_character = "*",
    -- The applied highlight group (colors) on the cloaking, see `:h highlight`.
    highlight_group = "Comment",
    patterns = {
        {
            file_pattern = {
                ".env*",
            },
            cloak_pattern = "=.+"
        },
    },
})
