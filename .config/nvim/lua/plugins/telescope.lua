return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-lua/popup.nvim" },
    { "nvim-telescope/telescope-fzy-native.nvim" },
    { "kyazdani42/nvim-web-devicons" },
    { "nvim-telescope/telescope-file-browser.nvim" },
    { "nvim-telescope/telescope-ui-select.nvim" },
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      dependencies = {
        "junegunn/fzf.vim",
        dependencies = {
          {
            "tpope/vim-dispatch",
            cmd = { "Make", "Dispatch" },
          },
        },
      },
    },
  },
  event = "VeryLazy",
  keys = {
    { "<C-p>", ":Telescope find_files<cr>" }, 
    { "<leader>f", ":Telescope find_files<cr>" },
  },
  opts = {
    defaults = {
      layout_strategy = 'horizontal',
      layout_config = {
        prompt_position = 'top'
      },
      sorting_strategy = "ascending",
      mappings = {
        i = {
          ["<esc>"] = "close",
          ["<C-c>"] = "close",
          ["<A-k>"] = "move_selection_next",
          ["<A-l>"] = "move_selection_previous",
        },
        n = {
          ["<esc>"] = "close",
          ["<C-c>"] = "close",
          ["<leader>q"] = "close",
          ["<A-k>"] = "move_selection_next",
          ["<A-l>"] = "move_selection_previous",
        }
      }
    }
  }
}
