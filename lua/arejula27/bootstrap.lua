--This function is binded ti VimEnter, which is call when vim loads.
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    local bufferPath = vim.fn.expand '%:p'
    if vim.fn.isdirectory(bufferPath) ~= 0 then
      local ts_builtin = require 'telescope.builtin'
      vim.api.nvim_buf_delete(0, { force = true })
      ts_builtin.find_files()
    end
  end,
})
