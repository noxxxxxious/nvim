return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  config = function()
    vim.opt.background = 'dark'
    vim.cmd([[colorscheme catppuccin-macchiato]])
    vim.cmd([[hi Normal guibg=NONE ctermbg=NONE]])
  end,
}

