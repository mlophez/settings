return {
  "github/copilot.vim",
  -- "zbirenbaum/copilot.lua",
  --lazy = false,
  config = function()
    vim.g.copilot_no_tab_map = true
    vim.api.nvim_set_keymap("i", "<A-Tab>", 'copilot#Accept("<CR>")', { expr = true, silent = true, noremap = true })
  end
}
