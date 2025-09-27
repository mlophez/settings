return {
	"NeogitOrg/neogit",
	enabled = false,
	cmd = { "Neogit" },
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"sindrets/diffview.nvim", -- optional - Diff integration
	},
	keys = {
		{ "<leader>g", ":Neogit<cr>", silent = true },
	},
	opts = {
		use_default_keymaps = true,
		--kind = "floating",
		--commit_editor = {
		--	kind = "floating",
		--},
		--commit_select_view = {
		--	kind = "floating",
		--},
		--commit_view = {
		--	kind = "floating",
		--},
		mappings = {
			commit_editor = {
				["q"] = "Close",
			},
			status = {
				["q"] = "Close",
				["o"] = "Toggle",
				["x"] = "Discard",
				["s"] = "Stage",
				["S"] = "StageUnstaged",
				["u"] = "Unstage",
				["U"] = "UnstageStaged",
				["r"] = "RefreshBuffer",
				["<enter>"] = "GoToFile",
			},
		},
	},
}
