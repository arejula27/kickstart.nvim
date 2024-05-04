-- bootstrap file this while  initiate vim
local is_git_dir = function()
  return os.execute 'git rev-parse --is-inside-work-tree >> /dev/null 2>&1'
end

--This function is binded ti VimEnter, which is call when vim loads.
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    local bufferPath = vim.fn.expand '%:p'
    if vim.fn.isdirectory(bufferPath) ~= 0 then
      local ts_builtin = require 'telescope.builtin'
      vim.api.nvim_buf_delete(0, { force = true })
      if is_git_dir() == true then
        ts_builtin.git_files { show_untracked = true }
      else
        ts_builtin.find_files()
      end
    end
  end,
})
