return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    enabled = false,
    ft = { "markdown" },
    --dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    -- @module 'render-markdown'
    -- @type render.md.UserConfig
    opts = {
      anti_conceal = {
        enabled = false,
      }
    },
  },
  {
    "tadmccorkle/markdown.nvim",
    ft = "markdown", -- or 'event = "VeryLazy"'
    opts = {
      -- configuration here or empty for defaults
      on_attach = function(bufnr)
        local map = vim.keymap.set
        local opts = { buffer = bufnr }
        map('n', '<CR>', '<cmd>MDTaskToggle<CR>', opts)
      end,
    },
  }
}
