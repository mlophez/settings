return {
  "kyazdani42/nvim-tree.lua",
  version = "ce3495b",
  dependencies = {
    { "kyazdani42/nvim-web-devicons" },
  },
  keys = {
    { "<leader>e", ":NvimTreeOpen<cr>" }, 
    { "<leader>b", ":NvimTreeClose<cr>" },
    { "<space>", ":NvimTreeFocusToggle<cr>" },
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

    local function is_modified_buffer_open(buffers)
      for _, v in pairs(buffers) do
        if v.name:match("NvimTree_") == nil then
          return true
        end
      end
      return false
    end
  
    vim.api.nvim_create_autocmd("BufEnter", {
      nested = true,
      callback = function()
        if
          #vim.api.nvim_list_wins() == 1
          and vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil
          and is_modified_buffer_open(vim.fn.getbufinfo({ bufmodified = 1 })) == false
        then
          vim.cmd("quit")
        end
      end,
    })

    vim.api.nvim_create_user_command('NvimTreeFocusToggle', function()
      --if (not require'nvim-tree.view'.win_open() or vim.bo.filetype ~= 'NvimTree') then
      --  vim.cmd('NvimTreeFindFileToggle')
      --else
      --  vim.cmd('NvimTreeFindFileToggle')
      --  vim.cmd('wincmd p')
      --end
      if vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil then
        vim.cmd('wincmd p')
      else
        require("nvim-tree.api").tree.focus()
      end
    end, {})

  end
}
