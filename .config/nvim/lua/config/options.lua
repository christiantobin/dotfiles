-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt
opt.wrap = true
opt.relativenumber = false -- Relative line numbers

vim.api.nvim_set_keymap("n", "<leader>th", ":sp | term<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>tv", ":vsp | term<CR>", { noremap = true, silent = true })
