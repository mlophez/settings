return {
  {
    "Mofiqul/dracula.nvim",
    enabled = false,
    name = "dracula",
    priority = 10000,
  },

  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
    enabled = false,
    priority = 10000,
    opts = { style = "moon" },
  },

  {
    -- catppuccin, catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
    -- vim.cmd.colorscheme("catppuccin-mocha")
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 10000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        background = {
          light = "latte",
          dark = "mocha",
        },
        transparent_background = true,
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  {
    "gbprod/nord.nvim",
    name = "nord",
    enabled = false,
    priority = 10000,
    install = {
      colorscheme = { "nord" },
    },
  },

  {
    "xiyaowong/transparent.nvim",
    enabled = false,
    lazy = false,
    priority = 10000,

    opts = {     -- Optional, you don't have to run setup.
      groups = { -- table: default groups
        "Normal",
        "NormalNC",
        "Comment",
        "Constant",
        "Special",
        "Identifier",
        "Statement",
        "PreProc",
        "Type",
        "Underlined",
        "Todo",
        "String",
        "Function",
        "Conditional",
        "Repeat",
        "Operator",
        "Structure",
        "LineNr",
        "NonText",
        "SignColumn",
        "CursorLineNr",
        "EndOfBuffer",
      },
      extra_groups = {},   -- table: additional groups that should be cleared
      exclude_groups = {}, -- table: groups you don't want to clear
    },
  }
}
