return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  opts = {
    copilot_model = "claude-sonnet-4",
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
