return {
	"nyoom-engineering/oxocarbon.nvim",
	priority = 1000,
	config = function()
		vim.cmd([[colorscheme oxocarbon]])
		-- Set the background to transparent
		vim.cmd([[highlight Normal guibg=none]])
		vim.cmd([[highlight NonText guibg=none]])
		vim.cmd([[highlight SignColumn guibg=none]])
		vim.cmd([[highlight LineNr guibg=none]])
	end,
}

