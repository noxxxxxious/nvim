return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons"
  },
  config = function()
    require("nvim-tree").setup {}

    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    vim.keymap.set('n', '<Leader>no', ':NvimTreeToggle<CR>')
    vim.keymap.set('n', '<Leader>nta', ':NvimTreeResize -10<CR>')
    vim.keymap.set('n', '<Leader>ntd', ':NvimTreeResize +10<CR>')
  end,
}

