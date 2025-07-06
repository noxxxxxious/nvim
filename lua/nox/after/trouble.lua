-- Open Trouble Quickfix when the qf list opens
-- This is NOT recommended, since you won't be able to use the quickfix list for other things.
-- ------ But we're gonna do it anyway

vim.api.nvim_create_autocmd("BufRead", {
  callback = function(ev)
    if vim.bo[ev.buf].buftype == "quickfix" then
      vim.schedule(function()
        vim.cmd([[cclose]])
        vim.cmd([[Trouble qflist open focus=true]])
      end)
    end
  end,
})
