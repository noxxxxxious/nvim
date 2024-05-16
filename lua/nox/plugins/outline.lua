return {
  "hedyhli/outline.nvim",
  lazy = true,
  cmd = { "Outline", "OutlineOpen" },
  keys = { -- Example mapping to toggle outline
    { "<leader>ol", "<cmd>Outline<CR>", desc = "Toggle [o]ut[l]ine" },
  },
  opts = {
    -- Your setup opts here
  },
}
