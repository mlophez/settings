return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = { "Trouble", "TroubleClose", "TroubleToggle", "TroubleRefresh" },
	keys = {
		{ "t", "<cmd>TroubleToggle<cr>", silent = true },
	},
	opts = {
		height = 20,
		action_keys = {
			-- map to {} to remove a mapping, for example:
			-- close = {},
			next = "k", -- next item
			previous = "l", -- previous item
			close = "q", -- close the list
			cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
			refresh = "r", -- manually refresh
			jump = {}, -- jump to the diagnostic or open / close folds
			open_split = {}, -- open buffer in new split
			open_vsplit = {}, -- open buffer in new vsplit
			open_tab = {}, -- open buffer in new tab
			jump_close = {}, -- jump to the diagnostic and close the list
			toggle_mode = {}, -- toggle between "workspace" and "document" diagnostics mode
			switch_severity = {}, -- switch "diagnostics" severity filter level to HINT / INFO / WARN / ERROR
			toggle_preview = {}, -- toggle auto_preview
			hover = {}, -- opens a small popup with the full multiline message
			preview = {}, -- preview the diagnostic location
			open_code_href = {}, -- if present, open a URI with more information about the diagnostic error
			close_folds = {}, -- close all folds
			open_folds = {}, -- open all folds
			toggle_fold = {}, -- toggle fold of current file
			help = "?", -- help menu
		},
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
	},
}
