return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	cmd = "Neotree",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	keys = {
		{ "m", ":Neotree position=float toggle<cr>", silent = true },
	},
	config = function()
		require("neo-tree").setup({
			popup_border_style = "rounded",
			enable_git_status = true,
			enable_diagnostics = true,
			use_default_mappings = false,
			--enable_normal_mode_for_inputs = false,
			window = {
				mapping_options = {
					noremap = true,
					nowait = true,
				},
				mappings = {
					["m"] = "close_window",
					--["l"] = function(state)
					--	local tree = state.tree
					--	local node = tree:get_node()
					--	local siblings = tree:get_nodes(node:get_parent_id())
					--	local renderer = require("neo-tree.ui.renderer")
					--	renderer.focus_node(state, siblings[1]:get_id())
					--end,
					["<space>"] = { "toggle_node", nowait = false },
					["o"] = "open",
					["<esc>"] = "cancel", -- close preview or floating neo-tree window
					["t"] = "open_tabnew",
					["z"] = "close_all_nodes",
					["Z"] = "expand_all_nodes",
					["a"] = { "add", config = { show_path = "none" } },
					["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
					["d"] = "delete",
					["r"] = "rename",
					["y"] = "copy_to_clipboard",
					["x"] = "cut_to_clipboard",
					["p"] = "paste_from_clipboard",
					-- ["c"] = "copy",
					["q"] = "close_window",
					["R"] = "refresh",
					["i"] = "show_file_details",
					["?"] = "show_help",
				},
			},
			filesystem = {
				window = {
					mappings = {
						["<bs>"] = "navigate_up",
						["."] = "set_root",
						["H"] = "toggle_hidden",
					},
				},
			},
		})
	end,
}
