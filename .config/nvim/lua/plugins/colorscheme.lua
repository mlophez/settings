return {
  {
    'Mofiqul/dracula.nvim',
    lazy = false,
    priority = 10000,
    config = function()
      vim.cmd.colorscheme("dracula")
    end
  },
  --"folke/tokyonight.nvim",
  --"lunarvim/darkplus.nvim",
}
