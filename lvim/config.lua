-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

require("brymck")

--------------------------
-- Treesitter
------------------------
lvim.builtin.treesitter.ensure_installed = {
    "go",
    "gomod",
    "java",
    "pantor"
}

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.pantor = {
    install_info = {
        url = "~/dev/tree-sitter-pantor",
        files = { "src/parser.c" },
    },
    filetype = "meta",
    highlight = {
        enable = true,
    },
}

vim.filetype.add({
    extension = {
        meta = "pantor"
    }
})

------------------------
-- Plugins
------------------------
lvim.plugins = {
    "ThePrimeagen/harpoon",
    "folke/zen-mode.nvim",
    "github/copilot.vim",
    "laytan/cloak.nvim",
    "leoluz/nvim-dap-go",
    "mbbill/undotree",
    "mfussenegger/nvim-jdtls",
    "olexsmir/gopher.nvim",
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({})
        end,
    },
    {
        "zbirenbaum/copilot-cmp",
        config = function()
            require("copilot_cmp").setup({
                suggestion = { enabled = false },
                panel = { enabled = false }
            })
        end
    }
}

------------------------
-- Formatting
------------------------
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    { command = "goimports", filetypes = { "go" } },
    { command = "gofumpt",   filetypes = { "go" } },
}

lvim.format_on_save = {
    pattern = { "*.go" },
}

------------------------
-- Dap
------------------------
local dap_ok, dapgo = pcall(require, "dap-go")
if not dap_ok then
    return
end

dapgo.setup()

------------------------
-- LSP
------------------------
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, {
    "gopls",
    "jdtls",
})

local lsp_manager = require "lvim.lsp.manager"
lsp_manager.setup("golangci_lint_ls", {
    on_init = require("lvim.lsp").common_on_init,
    capabilities = require("lvim.lsp").common_capabilities(),
})

lsp_manager.setup("gopls", {
    on_attach = function(client, bufnr)
        require("lvim.lsp").common_on_attach(client, bufnr)
        local _, _ = pcall(vim.lsp.codelens.refresh)
        local map = function(mode, lhs, rhs, desc)
            if desc then
                desc = desc
            end

            vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc, buffer = bufnr, noremap = true })
        end
        map("n", "<leader>Ci", "<cmd>GoInstallDeps<Cr>", "Install Go Dependencies")
        map("n", "<leader>Ct", "<cmd>GoMod tidy<cr>", "Tidy")
        map("n", "<leader>Ca", "<cmd>GoTestAdd<Cr>", "Add Test")
        map("n", "<leader>CA", "<cmd>GoTestsAll<Cr>", "Add All Tests")
        map("n", "<leader>Ce", "<cmd>GoTestsExp<Cr>", "Add Exported Tests")
        map("n", "<leader>Cg", "<cmd>GoGenerate<Cr>", "Go Generate")
        map("n", "<leader>Cf", "<cmd>GoGenerate %<Cr>", "Go Generate File")
        map("n", "<leader>Cc", "<cmd>GoCmt<Cr>", "Generate Comment")
        map("n", "<leader>DT", "<cmd>lua require('dap-go').debug_test()<cr>", "Debug Test")
    end,
    on_init = require("lvim.lsp").common_on_init,
    capabilities = require("lvim.lsp").common_capabilities(),
    settings = {
        gopls = {
            usePlaceholders = true,
            gofumpt = true,
            codelenses = {
                generate = false,
                gc_details = true,
                test = true,
                tidy = true,
            },
        },
    },
})

local status_ok, gopher = pcall(require, "gopher")
if not status_ok then
    return
end

gopher.setup {
    commands = {
        go = "go",
        gomodifytags = "gomodifytags",
        gotests = "gotests",
        impl = "impl",
        iferr = "iferr",
    },
}

local ok, copilot = pcall(require, "copilot")
if not ok then
    return
end

copilot.setup {
    suggestion = {
        keymap = {
            accept = "<c-l>",
            next = "<c-j>",
            prev = "<c-k>",
            dismiss = "<c-h>",
        },
    },
}

vim.api.nvim_set_keymap("n", "<c-s>", "<cmd>lua require('copilot.suggestion').toggle_auto_trigger()<CR>", {
    noremap = true,
    silent = true,
})

-- Below config is required to prevent copilot overriding Tab with a suggestion
-- when you're just trying to indent!
local has_words_before = function()
    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end
local on_tab = vim.schedule_wrap(function(fallback)
    local cmp = require("cmp")
    if cmp.visible() and has_words_before() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
    else
        fallback()
    end
end)
lvim.builtin.cmp.mapping["<Tab>"] = on_tab
