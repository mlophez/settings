return {
	defaults = {
		disable_devicons = true,
		layout_strategy = "horizontal",
		layout_config = {
			prompt_position = "top",
		},
		sorting_strategy = "ascending",
		mappings = {
			i = {
				["<esc>"] = "close",
				["<C-c>"] = "close",
			},
			n = {
				["<esc>"] = "close",
				["<C-c>"] = "close",
				["q"] = "close",
			},
		},
	},
}
