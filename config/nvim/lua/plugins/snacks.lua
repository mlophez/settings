return {
  "folke/snacks.nvim",
  priority = 102,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    lazygit = { enabled = true },
    picker = { enabled = true },
    input = { enabled = true },
    -- scroll = { enabled = true }
    -- rename = { enabled = false },
    -- bufdelete = { enabled = true },
  },
  keys = {
    { "<leader>cr", function() Snacks.rename.rename_file() end,  desc = "Rename File" },
    { "<leader>g",  function() Snacks.lazygit() end,             desc = "Lazygit" },
    { "<leader>gl", function() Snacks.picker.git_log_file() end, desc = "Git file history" },
    --{ "<leader>gl", function() Snacks.lazygit.log() end,        desc = "Lazygit Log (cwd)" },
    -- pickers (migrated from telescope.nvim)
    { "<C-p>",     function() Snacks.picker.files() end,      desc = "Find Files" },
    { "<leader>f", function() Snacks.picker.files() end,      desc = "Find Files" },
    { "<leader>s", function() Snacks.picker.grep() end,       desc = "Live Grep" },
    { "<leader>gf", function() Snacks.picker.treesitter() end, desc = "Treesitter Symbols" },
    { "<leader>fh", function() Snacks.picker.help() end,      desc = "Help Tags" },
    { "<leader>b",  function() Snacks.picker.buffers() end,   desc = "Buffers" },
  }
}
