-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Unmap the previous <leader>sr to avoid conflicts
vim.keymap.del("n", "<leader>sr")

-- Normal mode: search and replace with Spectre instead of default tool
vim.keymap.set("n", "<leader>sr", '<cmd>lua require("spectre").open()<CR>', { desc = "Search and Replace (Spectre)" })
vim.api.nvim_set_keymap(
    "n",
    "<leader>sb",
    '<cmd>lua require("spectre").open_file_search()<CR>',
    { noremap = true, silent = true, desc = "Search in Buffer" }
)

-- Visual mode: search and replace selected text with Spectre
vim.keymap.set(
    "v",
    "<leader>sr",
    '<cmd>lua require("spectre").open_visual()<CR>',
    { desc = "Search and Replace Selection (Spectre)" }
)

-- Disable arrow keys for basic traversal in normal and visual modes
vim.api.nvim_set_keymap("n", "<Up>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Down>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Left>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Right>", "<Nop>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("v", "<Up>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<Down>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<Left>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<Right>", "<Nop>", { noremap = true, silent = true })
