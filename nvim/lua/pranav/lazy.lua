local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Configure lazy.nvim
require("lazy").setup({
  spec = {
    { import = "pranav.plugins" },
    { import = "pranav.plugins.lsp" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  checker = {
    enabled = false,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
})

vim.g.tmux_navigator_disable_netrw_workaround = 1
