local highlight = {
    "CursorColumn",
    "Whitespace",
}
return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  ---@module "ibl"
  ---@type ibl.config
  opts = {
    indent = {
      char = "▍"
    },
    exclude = {
      filetypes = {"dashboard"}
    },
    scope = {
       enabled = true,
       show_start = true,
       show_end = false,
       injected_languages = true,
       highlight = { "Function", "Label" },
       priority = 500,
    }
  },
}
