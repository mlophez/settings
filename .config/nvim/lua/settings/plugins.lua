-- https://www.lazyvim.org/plugins/lsp
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

local opts = {
	lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
  default = {
    lazy = true
  },
	change_detection = {
		notify = false,
	},
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      }
    }
  }
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
require("lazy").setup("plugins", opts)

-- local setup = {
-- 	{ import = "plugins.core" },
-- 	{ import = "plugins.lsp" },
-- 	{ import = "plugins.ui" },
-- 	{ import = "plugins.utils" },
-- }
