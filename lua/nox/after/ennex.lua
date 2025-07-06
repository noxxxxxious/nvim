local parser_configs = require'nvim-treesitter.parsers'.get_parser_configs()

parser_configs.ennex = {
  install_info = {
    url = '~/Programming/Ennex/grammar',
    files = { 'src/parser.c' },
    generate_requires_npm = false,
    requires_generate_from_grammar = true,
  },
  filetype = 'nx',
}

vim.treesitter.language.register('ennex', 'nx')
vim.filetype.add({
  extension = {
    nx = 'ennex',
  }
})
