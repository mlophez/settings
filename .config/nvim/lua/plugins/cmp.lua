return {
  'hrsh7th/nvim-cmp',
  --enabled = require('plugins.lspconfig').enabled,
  enabled = false,
  event = "InsertEnter",
  dependencies = {
    -- Autocompletion
    {'hrsh7th/cmp-buffer'},       -- Optional
    {'hrsh7th/cmp-path'},         -- Optional
    {'hrsh7th/cmp-nvim-lsp'},     -- Required
    {'hrsh7th/cmp-nvim-lua'},     -- Optional

    -- Snippets
    {'L3MON4D3/LuaSnip'},             -- Required
    {'rafamadriz/friendly-snippets'}, -- Optional
  }
}
