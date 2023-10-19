local M = {}

M.plugins = {
	-- colorschemes ---
	"folke/tokyonight.nvim",
	"Mofiqul/dracula.nvim",
	"catppuccin/nvim",
	"gbprod/nord.nvim",

	-- ui --
	"akinsho/bufferline.nvim",
	"utilyre/barbecue.nvim",
	"nvim-lualine/lualine.nvim",
	"rcarriga/nvim-notify",
	"folke/noice.nvim",

	-- files --
	"kyazdani42/nvim-tree.lua",
	"nvim-telescope/telescope.nvim",

	-- installers --
	"williamboman/mason.nvim",

	-- parsers --
	"nvim-treesitter/nvim-treesitter",

	-- -- lsp, format, lint --
	"neovim/nvim-lspconfig",
	"stevearc/conform.nvim",
	-- "mfussenegger/nvim-lint",

	-- AutoComplete --
	"hrsh7th/nvim-cmp",

	-- markdown --
	--"toppair/peek.nvim",

	-- utils --
	"alexghergh/nvim-tmux-navigation",
	"lukas-reineke/indent-blankline.nvim",
	"akinsho/toggleterm.nvim",
	-- "xiyaowong/transparent.nvim",

	-- "echasnovski/mini.comment",,
	-- "echasnovski/mini.pairs",,
	-- "rest-nvim/rest.nvim",,
	-- -- "jakewvincent/mkdnflow.nvimplug",,
	-- -- "kristijanhusak/vim-dadbod-ui",,
}

M.imports = {
	{ import = "plugins.specs" },
}

function M.is(cname)
	for _, name in pairs(M.plugins) do
		if name == cname then
			return true
		end
	end
	return false
end

function M.load(name, spec)
	spec.name = name
	spec.enabled = false

	for _, cname in pairs(M.plugins) do
		if spec[1] == cname or name == cname then
			spec.enabled = true
			return spec
		end
	end

	return spec
end

return M
