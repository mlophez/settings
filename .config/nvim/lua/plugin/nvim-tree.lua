local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  return
end

local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
if not config_status_ok then
  return
end

local tree_cb = nvim_tree_config.nvim_tree_callback

nvim_tree.setup {
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
  renderer = {
    root_folder_modifier = ":t",
    icons = {
      glyphs = {
        default = "",
        symlink = "",
        folder = {
          arrow_open = "",
          arrow_closed = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "",
          staged = "S",
          unmerged = "",
          renamed = "➜",
          untracked = "U",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  view = {
    width = 30,
    side = "left",
    hide_root_folder = true,
    mappings = {
      list = {
        { key = { "ñ", "<CR>", "o" }, cb = tree_cb "edit" },
        { key = "j", cb = tree_cb "close_node" },
        { key = "v", cb = tree_cb "vsplit" },
        { key = "c", cb = tree_cb "create" },
        { key = "r", cb = tree_cb "rename" },
      },
    },
  },
  filters = {
    custom = { "^\\.git", "^\\.terraform" },
    exclude = { ".gitignore" },
  },
}

vim.api.nvim_set_keymap("n", "<leader>e", ":NvimTreeOpen<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>b", ":NvimTreeClose<cr>", { noremap = true, silent = true })

-- Close
vim.api.nvim_set_keymap("n", "<leader>q", ":NvimTreeClose<cr>:q<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>x", ":NvimTreeClose<cr>:x<cr>", { noremap = true, silent = true })


