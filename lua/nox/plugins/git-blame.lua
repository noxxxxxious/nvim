return {
  'f-person/git-blame.nvim',
  config = function()
    require'gitblame'.setup{
      message_template = "[<sha>][<date>] <author> → <summary>",
      date_format = "%a %b %d %Y"
    }
  end,
}
