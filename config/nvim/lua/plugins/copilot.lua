return {
  "zbirenbaum/copilot.lua",
  enabled = false,
  cmd = "Copilot",
  event = "InsertEnter",
  opts = {
    -- copilot_model = "gpt-41-copilot", -- (optional) se pone en avante
    suggestion = {
      auto_trigger = true,
      debounce = 50,
      keymap = {
        accept = "<A-Tab>",
      },
    }
  },
  --dependencies = {
  --  "copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
  --},
}
