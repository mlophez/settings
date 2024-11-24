return {
  {
    "mfussenegger/nvim-dap",
    dependencies = { "leoluz/nvim-dap-go" },
    keys = {
      { "<leader>dt", function() require('dap').toggle_breakpoint() end, silent = true },
      { "<leader>dc", function() require('dap').continue() end,          silent = true },
    },
    --opts = {}
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    keys = {
      { "<leader>dd", function() require("dapui").toggle() end, silent = true },
    },
    opts = {}
  },
  {
    "leoluz/nvim-dap-go",
    ft = { "go", "gosum", "gomod" },
    dependencies = { "mfussenegger/nvim-dap", "rcarriga/nvim-dap-ui" },
    opts = {}
  },

}
