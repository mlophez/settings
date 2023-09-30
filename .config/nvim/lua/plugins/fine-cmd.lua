return {
  'VonHeikemen/fine-cmdline.nvim',
  enabled = true,
  dependencies = {
    {'MunifTanjim/nui.nvim'}
  },
  keys = {
    { "<space>", "<cmd>FineCmdline<cr>", }
  },
  opts = {
    popup = {
      position = {
        row = '45%',
        col = '50%'
      }
    }
  }
}
