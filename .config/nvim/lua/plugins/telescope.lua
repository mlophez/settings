return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    -- fzf integration --
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "junegunn/fzf.vim" },
    { "tpope/vim-dispatch",                       cmd = { "Make", "Dispatch" } },
  },
  keys = {
    { "<C-p>",      ":Telescope find_files<cr>", silent = true },
    { "<leader>f",  ":Telescope find_files<cr>", silent = true },
    { "<leader>fh", ":Telescope help_tags<cr>",  silent = true },
    { "<leader>s",  ":Telescope live_grep<cr>",  silent = true },
    { "<leader>b",  ":Telescope buffers<cr>",    silent = true },
    { "<TAB>",      ":Telescope buffers<cr>",    silent = true },
    { "<leader>c",  ":Telescope commands<cr>",   silent = true },
    { "<leader>gf", ":Telescope git_files<cr>",  silent = true },
    { "<leader>gs", ":Telescope git_status<cr>", silent = true },
  },
  opts = {
    defaults = {
      disable_devicons = true,
      layout_strategy = "horizontal",
      layout_config = {
        prompt_position = "top",
      },
      sorting_strategy = "ascending",
      mappings = {
        i = {
          ["<esc>"] = "close",
          ["<C-c>"] = "close",
        },
        n = {
          ["<esc>"] = "close",
          ["<C-c>"] = "close",
          ["q"] = "close",
        },
      },
    },
  },
}
