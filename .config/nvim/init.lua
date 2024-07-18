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

-- Set highlight groups for transparency
vim.cmd([[
  highlight Normal guibg=none ctermbg=none
  highlight NonText guibg=none ctermbg=none
  highlight LineNr guibg=none ctermbg=none
  highlight Folded guibg=none ctermbg=none
  highlight EndOfBuffer guibg=none ctermbg=none
  highlight SignColumn guibg=none ctermbg=none
  highlight StatusLineNC guibg=none ctermbg=none
  highlight VertSplit guibg=none ctermbg=none
  highlight TabLine guibg=none ctermbg=none
  highlight TabLineFill guibg=none ctermbg=none
  highlight TabLineSel guibg=none ctermbg=none

  " Additional highlight groups for Neo-tree
  highlight NeoTreeNormal guibg=none ctermbg=none
  highlight NeoTreeEndOfBuffer guibg=none ctermbg=none

  " Highlight groups for which-key
  highlight WhichKey guibg=none ctermbg=none
  highlight WhichKeyFloat guibg=none ctermbg=none
  highlight WhichKeyGroup guibg=none ctermbg=none
  highlight WhichKeyDesc guibg=none ctermbg=none
  highlight WhichKeySeperator guibg=none ctermbg=none
  highlight WhichKeyValue guibg=none ctermbg=none
]])

