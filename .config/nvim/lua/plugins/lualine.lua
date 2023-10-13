return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"kyazdani42/nvim-web-devicons",
	},
	opts = {
		options = {
			theme = "auto",
			icons_enabled = true,
			global_status = true,
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { { "branch", icon = "" } },
			lualine_c = {
				{ "filename", file_status = "true", path = 1 },
			},
			lualine_x = {
				{ "diagnosis", sources = { "nvim" } },
				"diff",
			},
			lualine_y = { "filetype" },
			lualine_z = { "location" },
		},
		tabline = {},
		extensions = {},
	},
	enabled = true,
}
