return {
	'mbbill/undotree',
	config = function()
		vim.keymap.set('n', '<Leader>ut', ':UndotreeToggle<CR>')
	end
}
