return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	end,
	config = function()
		require("which-key").register {
			["<Leader>n"] = { name = "[n]ox", _ = 'which_key_ignore' },
			["<Leader>c"] = { name = "[c]hange", _ = 'which_key_ignore' },
			["<Leader>s"] = { name = "[s]plit / [s]how", _ = 'which_key_ignore' },
			["<Leader><Tab>"] = { name = "[tab] commands", _ = 'which_key_ignore' },
		}
	end
}
