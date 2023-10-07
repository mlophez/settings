-- https://www.lazyvim.org/plugins/lsp
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

local opts = {
  lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
  change_detection = {
    notify = false,
  },
}

local setup = {
  { import = "plugins.core" },
  { import = "plugins.lsp" },
  { import = "plugins.ui" },
  { import = "plugins.utils" }
}

-- Setup --
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
require("lazy").setup(setup, opts)
