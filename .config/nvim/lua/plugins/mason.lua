return {
  'williamboman/mason.nvim',
  enabled = require('plugins.lspconfig').enabled,
  dependencies = {
    { "williamboman/mason-lspconfig.nvim", opts = { automatic_installation = true } },
  },
  opts = {
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗"
      }
    }
  }
}
