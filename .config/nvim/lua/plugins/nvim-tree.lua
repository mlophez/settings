return {
  "kyazdani42/nvim-tree.lua",
  version = "ce3495b",
  dependencies = {
    { "kyazdani42/nvim-web-devicons" },
  },
  keys = {
    { "<leader>e", ":NvimTreeOpen<cr>" }, 
    { "<leader>b", ":NvimTreeClose<cr>" },
    --{ "<space>", ":NvimTreeFocus<cr>" },
  },
  opts = {
    update_focused_file = {
      enable = true,
      update_cwd = true,
    },
    renderer = {
      root_folder_label = false,
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
      width = 50,
      side = "right",
      --mappings = {
      --  list = {
      --    { key = { "ñ", "<CR>", "o" }, action = "edit" },
      --    { key = "j", action = "close_node" },
      --    { key = "v", action = "vsplit" },
      --    { key = "c", action = "create" },
      --    { key = "r", action = "rename" },
      --  },
      --},
    },
    actions = {
      open_file = {
        quit_on_open = false,
      }
    },
    filters = {
      custom = { "^\\.git", "^\\.terraform" },
      exclude = { ".gitignore" },
    },
  },
  init = function()
    require("nvim-tree.api").tree.open()
  end
}
