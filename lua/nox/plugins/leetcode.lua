return {
	'kawre/leetcode.nvim',
	build = ':TSUpdate html',
	dependencies = {
		'nvim-telescope/telescope.nvim',
		'nvim-lua/plenary.nvim',
		'nvim-treesitter/nvim-treesitter',
		'muniftanjim/nui.nvim',
		'rcarriga/nvim-notify',
		'nvim-tree/nvim-web-devicons',
	},
	opts = {
		lang = 'typescript',
	},
}
