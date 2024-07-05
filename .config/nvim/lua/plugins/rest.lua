return {
  "rest-nvim/rest.nvim",
  enabled = false,

  ft = "http",

  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      {
        "vhyrro/luarocks.nvim",
        priority = 1000,
        config = true,
        opts = {
          rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua" }
        }
      },
    }
  },

  opts = {
    skip_ssl_verification = true,
  },

  config = function(_, opts)
    require("rest-nvim").setup(opts)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "http",
      callback = function()
        local kopts = { noremap = true, silent = true, buffer = tonumber(vim.fn.expand("<abuf>", 10)) }
        vim.keymap.set("n", "<cr>", "<cmd>Rest run<cr>", kopts)
      end,
    })
  end,
}
