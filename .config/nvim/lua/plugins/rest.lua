return {
  "rest-nvim/rest.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  main = "rest-nvim",
  opts = {
    skip_ssl_verification = true,
  },
  init = function ()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = 'http',
      callback = function ()
        local opts = { noremap = true, silent = true, buffer = tonumber(vim.fn.expand("<abuf>", 10)) }
        vim.keymap.set("n", "<cr>", "<Plug>RestNvim", opts)
      end
    })
  end
}
