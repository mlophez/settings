local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local function open_multiple_files(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local entries = picker:get_multi_selection()

  actions.close(prompt_bufnr)

  if #entries > 0 then
    for _, entry in ipairs(entries) do
      -- Fix name when opeing from fzf: example: terraform_modules.tf:1:1:module
      -- We only want the file path before the first colon
      local file_path = entry.value:match("^[^:]+") or entry.value
      vim.cmd("edit " .. file_path)
    end
  else
    vim.cmd("edit " .. action_state.get_selected_entry().value)
  end
end

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
    { "<C-p>",      ":Telescope find_files<cr>",   silent = true },
    { "<leader>f",  ":Telescope find_files<cr>",   silent = true },
    { "<leader>fh", ":Telescope help_tags<cr>",    silent = true },
    { "<leader>s",  ":Telescope live_grep<cr>",    silent = true },
    { "<leader>b",  ":Telescope buffers<cr>",      silent = true },
    --{ "<TAB>",      ":Telescope buffers<cr>",      silent = true },
    { "<leader>c",  ":Telescope commands<cr>",     silent = true },
    { "<leader>gf", ":Telescope git_files<cr>",    silent = true },
    { "<leader>gs", ":Telescope git_status<cr>",   silent = true },
    { "<leader>gb", ":Telescope git_branches<cr>", silent = true },
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
          ["<C-o>"] = open_multiple_files,
        },
        n = {
          ["<esc>"] = "close",
          ["<BS>"] = "close",
          --["<TAB>"] = "close",
          ["<C-c>"] = "close",
          ["q"] = "close",
        },
      },
    },
  },
}
