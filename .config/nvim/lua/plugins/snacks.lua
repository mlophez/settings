return {
  "folke/snacks.nvim",
  priority = 102,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    -- bufdelete = { enabled = true },
    quickfile = { enabled = true },
    rename = { enabled = true },
    lazygit = { enabled = true },
    scroll = { enabled = true }
  },
  keys = {
    { "<leader>cr", function() Snacks.rename.rename_file() end, desc = "Rename File" },
    { "<leader>g",  function() Snacks.lazygit() end,            desc = "Lazygit" },
    --{ "<leader>gl", function() Snacks.lazygit.log() end,        desc = "Lazygit Log (cwd)" },
  }
}
