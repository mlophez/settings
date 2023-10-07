return {
  'williamboman/mason.nvim',
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
