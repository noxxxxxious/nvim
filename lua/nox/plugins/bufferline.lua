return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		require"bufferline".setup {
			options = {
				numbers = function(opts)
					return string.format('%s]', opts.ordinal)
				end,
				offsets = {
					{
						filetype = "NvimTree",
						text = "noxxxxxplorer",
						highlight = "Directory",
						separator = true -- use a "true" to enable the default, or set your own character
					}
				},
			},
		}

		vim.keymap.set('n', '<Leader><Tab>1', ':BufferLineGoToBuffer 1<CR>')
		vim.keymap.set('n', '<Leader><Tab>2', ':BufferLineGoToBuffer 2<CR>')
		vim.keymap.set('n', '<Leader><Tab>3', ':BufferLineGoToBuffer 3<CR>')
		vim.keymap.set('n', '<Leader><Tab>4', ':BufferLineGoToBuffer 4<CR>')
		vim.keymap.set('n', '<Leader><Tab>5', ':BufferLineGoToBuffer 5<CR>')
		vim.keymap.set('n', '<Leader><Tab>6', ':BufferLineGoToBuffer 6<CR>')
		vim.keymap.set('n', '<Leader><Tab>7', ':BufferLineGoToBuffer 7<CR>')
		vim.keymap.set('n', '<Leader><Tab>8', ':BufferLineGoToBuffer 8<CR>')
		vim.keymap.set('n', '<Leader><Tab>9', ':BufferLineGoToBuffer 9<CR>')
		vim.keymap.set('n', '<Leader><Tab>0', ':BufferLineGoToBuffer 10<CR>')
		vim.keymap.set('n', '<Leader><Tab>q', ':BufferLinePickClose<CR>')
		vim.keymap.set('n', '<Leader><Tab>cl', ':BufferLineCloseLeft<CR>')
		vim.keymap.set('n', '<Leader><Tab>cr', ':BufferLineCloseRight<CR>')
		vim.keymap.set('n', '<Leader><Tab>ca', ':BufferLineCloseOthers<CR>')
	end,
}
