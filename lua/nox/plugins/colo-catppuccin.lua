return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		vim.opt.background = "dark"
		vim.cmd([[colorscheme catppuccin-frappe]])
	end,
}
