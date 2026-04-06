-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--

-- Open PDFs in xdg-open instead of as text buffers
vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern = "*.pdf",
  callback = function(ev)
    vim.fn.jobstart({ "xdg-open", ev.file }, { detach = true })
    vim.api.nvim_buf_delete(ev.buf, {})
  end,
})
