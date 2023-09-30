return {
  -- "Mofiqul/dracula.nvim",
  -- "ellisonleao/gruvbox.nvim"
  "catppuccin/nvim", 
  lazy = false,
  priority = 10000,
  config = function()
    -- vim.cmd.colorscheme("dracula")
    -- vim.cmd.colorscheme("gruvbox")
    -- catppuccin, catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
    vim.cmd.colorscheme("catppuccin-macchiato")
  end
  --"folke/tokyonight.nvim",
  --"lunarvim/darkplus.nvim",
}
