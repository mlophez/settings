local tokyonight = {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 10000,
  config = function(_, opts)
    require('tokyonight').setup(opts)
    vim.cmd.colorscheme("tokyonight")
  end,
  opts = { style = "moon" },
}

local dracula = {
  "Mofiqul/dracula.nvim",
  lazy = false,
  priority = 10000,
  config = function()
    vim.cmd.colorscheme("dracula")
    -- catppuccin, catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
    --vim.cmd.colorscheme("catppuccin-mocha")
  end
}

local catppuccin = {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 10000,
  config = function(_, opts)
    -- catppuccin, catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
    require('catppuccin').setup(opts)
    vim.cmd.colorscheme("catppuccin-mocha")
  end,
  opts = {
    integrations = {
      alpha = true,
      cmp = true,
      flash = true,
      gitsigns = true,
      illuminate = true,
      indent_blankline = { enabled = true },
      lsp_trouble = true,
      mason = true,
      mini = true,
      native_lsp = {
        enabled = true,
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
      },
      navic = { enabled = true, custom_bg = "lualine" },
      neotest = true,
      noice = true,
      notify = true,
      neotree = true,
      semantic_tokens = true,
      telescope = true,
      treesitter = true,
      which_key = true,
    },
  },
}

return catppuccin
