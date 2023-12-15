return {
	"github/copilot.vim",
	config = function()
		vim.keymap.set("n", "<leader>cp", ":Copilot<CR>")
	end,
}
