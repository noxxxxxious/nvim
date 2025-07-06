return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  config = function()
    require'catppuccin'.setup{
      transparent_background = true,
      color_overrides = {
        all = {
          peach = '#eed49f'
        }
      }
    }

    vim.cmd.colorscheme "catppuccin-macchiato"
  end,
}

