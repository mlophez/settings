-- https://platform.openai.com/docs/models/gpt-3-5
local loader = require("plugins.loader").load
return loader("chatgpt", {
	"jackMort/ChatGPT.nvim",

	--event = "VeryLazy",
	cmd = { "ChatGPT", "ChatGPTRun", "ChatGPTActAs", "ChatGPTCompleteCode", "ChatGPTEditWithInstructions" },

	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},

	keys = {
		{ "<leader>i", ":ChatGPT<cr>", silent = true },
	},

	opts = {
		-- Models: gpt-3.5-turbo, gpt-4
		api_key_cmd = "pass chatgpt/token",
		openai_params = {
			model = "gpt-4",
		},
		openai_edit_params = {
			model = "gpt-4",
		},
		chat = {
			keymaps = {
				close = { "<C-c>" },
				yank_last = "<C-y>",
				yank_last_code = "<C-k>",
				scroll_up = "<C-u>",
				scroll_down = "<C-d>",
				new_session = "<C-n>",
				cycle_windows = "<Tab>",
				cycle_modes = "<C-f>",
				next_message = "<C-j>",
				prev_message = "<C-k>",
				select_session = "<Space>",
				rename_session = "r",
				delete_session = "d",
				draft_message = "<C-d>",
				edit_message = "e",
				delete_message = "d",
				toggle_settings = "<C-o>",
				toggle_message_role = "<C-r>",
				toggle_system_role_open = "<C-s>",
				stop_generating = "<C-x>",
			},
		},
	},

	--config = function(_, opts)
	--	require("chatgpt").setup(opts)
	--end,
})
