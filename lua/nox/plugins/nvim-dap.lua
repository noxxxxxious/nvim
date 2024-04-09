return {
	"mfussenegger/nvim-dap",
	config = function()
		vim.keymap.set('n', '<Leader>ndb', ':DapToggleBreakpoint<CR>', { desc = '[d]ebug toggle [b]reakpoint' })
		vim.keymap.set('n', '<Leader>ndi', ':DapStepInto<CR>', { desc = '[d]ebug step [i]nto' })
		vim.keymap.set('n', '<Leader>ndso', ':DapStepOut<CR>', { desc = '[d]ebug [s]tep [o]ut' })
		vim.keymap.set('n', '<Leader>ndo', ':DapStepOver<CR>', { desc = '[d]ebug step [o]ver' })
		vim.keymap.set('n', '<Leader>ndr', ':DapRestartFrame<CR>', { desc = '[d]ebug [r]estart frame' })
		vim.keymap.set('n', '<Leader>ndt', ':DapTerminate<CR>', { desc = '[d]ebug [t]erminate' })
		vim.keymap.set('n', '<Leader>ndl', ':DapShowLog<CR>', { desc = '[d]ebug show [l]og' })
	end,
}
