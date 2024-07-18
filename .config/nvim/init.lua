-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Set up the tokyonight colorscheme
require("tokyonight").setup({
    style = "moon", -- You can choose between 'storm', 'night', and 'day'
    transparent = true, -- Enable transparent background
    terminal_colors = true, -- Enable terminal colors
    styles = {
        floats = "transparent", -- Make floating windows transparent
        sidebars = "transparent", -- Make sidebars transparent
    },
})

vim.cmd("colorscheme tokyonight")
