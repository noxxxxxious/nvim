return {
  "AckslD/nvim-neoclip.lua",
  requires = {
    {'nvim-telescope/telescope.nvim'},
    {'ibhagwan/fzf-lua'},
  },
  config = function()
    require('neoclip').setup()
    vim.keymap.set('n', '<leader>sy', ':Telescope neoclip<CR>', { desc = '[S]earch previous [Y]anks' })
  end,
}
