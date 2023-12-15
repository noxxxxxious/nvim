return {
	"tpope/vim-fugitive",
	config = function()
		vim.keymap.set("n", "<leader>ngg", ":Git<CR>", { desc = "[g]it" })
		vim.keymap.set("n", "<leader>ngs", ":Git<CR>", { desc = "git [s]tatus" })
		vim.keymap.set("n", "<leader>ngaa", ":Git add --all<CR>", { desc = "git add --[a]ll" })
		vim.keymap.set("n", "<leader>ngap", ":Git add --patch<CR>", { desc = "git add --[p]atch" })
		vim.keymap.set("n", "<leader>ngc", ":Git commit<CR>", { desc = "git [c]ommit" })
		vim.keymap.set("n", "<leader>ngpl", ":Git pull<CR>", { desc = "git pu[l]l" })
		vim.keymap.set("n", "<leader>ngps", ":Git push<CR>", { desc = "git pu[s]h" })
	end,
}
