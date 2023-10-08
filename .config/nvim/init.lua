-- init.lua

Plugins = {
  -- ui --
  lualine = true,
  bufferline = true,
  -- files --
  nvim_tree = true,
  telescope = true,
  -- term --
  toggleterm = true,
  -- lang --
  treesitter = true,
  -- formatter --
  conform = true,
  -- lsp --
  mason = true,
  lsp = true,
  cmp = true,
  lint = true,
  -- utils --
  tmux_navigation = true,
}

require "settings.options"
require "settings.keymaps"
require "settings.filetype"
require "settings.plugins"
