return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	--init = function()
	--	vim.opt.conceallevel = 1
	--end,
	opts = {
		ui = {
			enable = false,
		},
		notes_subdir = "pkm",
		disable_frontmatter = true,
		workspaces = {
			{
				name = "notes",
				path = "~/Documents/Notes",
			},
		},
		mappings = {
			-- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
			["<cr>"] = {
				action = function()
					return require("obsidian").util.gf_passthrough()
				end,
				opts = { noremap = false, expr = true, buffer = true },
			},
			-- Toggle check-boxes.
			["<leader>m"] = {
				action = function()
					return require("obsidian").util.toggle_checkbox()
				end,
				opts = { buffer = true },
			},
		},
		note_id_func = function(title)
			return title
		end,
	},
}
