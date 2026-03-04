return {
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = {
            -- Optional keybinds for TypeScript tools
            on_attach = function(client, bufnr)
                local map = function(keys, func, desc)
                    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
                end

                map("<leader>co", function()
                    vim.cmd("TSToolsOrganizeImports")
                end, "Organize Imports")

                map("<leader>cu", function()
                    vim.cmd("TSToolsRemoveUnused")
                end, "Remove Unused Imports")

                map("<leader>cf", function()
                    vim.cmd("TSToolsFixAll")
                end, "Fix All")
            end,
        },
    },
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                vtsls = false, -- 🚫 prevent lspconfig from enabling vtsls
            },
            setup = {
                vtsls = function()
                    return true -- disables LazyVim's automatic setup
                end,
            },
        },
    },
}
