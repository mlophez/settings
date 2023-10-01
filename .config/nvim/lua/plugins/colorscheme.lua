return {
  -- "Mofiqul/dracula.nvim",
  -- "ellisonleao/gruvbox.nvim"
  "catppuccin/nvim", 
  dependencies = {
    "Mofiqul/dracula.nvim",
    "ellisonleao/gruvbox.nvim"
  },
  lazy = false,
  priority = 10000,
  config = function()
    -- vim.cmd.colorscheme("dracula")
    -- vim.cmd.colorscheme("gruvbox")
    -- catppuccin, catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
    vim.cmd.colorscheme("catppuccin-mocha")
  end
  --"folke/tokyonight.nvim",
  --"lunarvim/darkplus.nvim",
}
