-- Maintained fork of norcalli/nvim-colorizer.lua (the original calls the deprecated vim.tbl_flatten)
return {
	"catgoose/nvim-colorizer.lua",
	event = "VeryLazy",
	opts = {
		-- Highlight colors in every filetype
		filetypes = { "*" },
	},
}
