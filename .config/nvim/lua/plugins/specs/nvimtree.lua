local loader = require("plugins.loader").load
local spec = {
	"kyazdani42/nvim-tree.lua",
	version = "*",
	--lazy = false,
	--event = "VimEnter",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
}

spec.keys = {
	{ "m", ":NvimTreeToggle<cr>", silent = true },
	{ "<leader>e", ":NvimTreeFocusToggle<cr>", silent = true },
	{ "<C-e>", ":NvimTreeFocusToggle<cr>", silent = true },
	{ "<leader>b", ":NvimTreeClose<cr>", silent = true },
	--{ "<leader>e", ":NvimTreeOpen<cr>", silent = true },
}

spec.opts = {
	update_focused_file = {
		enable = true,
		update_cwd = true,
	},
	renderer = {
		root_folder_label = false,
		root_folder_modifier = ":t",
		icons = {
			git_placement = "after",
			glyphs = {
				default = "󰈚",
				symlink = "",
				folder = {
					default = "",
					empty = "",
					empty_open = "",
					open = "",
					symlink = "",
					symlink_open = "",
					arrow_open = "",
					arrow_closed = "",
				},
				git = {
					unstaged = "✗",
					staged = "✓",
					unmerged = "",
					renamed = "➜",
					untracked = "★",
					deleted = "",
					ignored = "◌",
				},
			},

			--glyphs = {
			--	default = "",
			--	symlink = "",
			--	folder = {
			--		arrow_open = "",
			--		arrow_closed = "",
			--		default = "",
			--		open = "",
			--		empty = "",
			--		empty_open = "",
			--		symlink = "",
			--		symlink_open = "",
			--	},
			--	git = {
			--		unstaged = "",
			--		staged = "S",
			--		unmerged = "",
			--		renamed = "➜",
			--		untracked = "U",
			--		deleted = "",
			--		ignored = "◌",
			--	},
			--},
		},
	},
	diagnostics = {
		enable = true,
		show_on_dirs = true,
		icons = {
			hint = "",
			info = "",
			warning = "",
			error = "",
		},
	},
	view = {
		width = 50,
		side = "left",
		--mappings = {
		--  list = {
		--    { key = { "ñ", "<CR>", "o" }, action = "edit" },
		--    { key = "j", action = "close_node" },
		--    { key = "v", action = "vsplit" },
		--    { key = "c", action = "create" },
		--    { key = "r", action = "rename" },
		--  },
		--},
	},
	actions = {
		open_file = {
			quit_on_open = true,
		},
	},
	filters = {
		custom = { "^\\.git", "^\\.terraform" },
		exclude = { ".gitignore" },
	},
	on_attach = function(bufnr)
		local api = require("nvim-tree.api")

		local opts = function(desc)
			return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
		end

		--vim.keymap.set("n", "<C-k>", api.node.show_info_popup, opts("Info"))
		--vim.keymap.set("n", "<C-r>", api.fs.rename_sub, opts("Rename: Omit Filename"))
		--vim.keymap.set("n", "<Tab>", api.node.open.preview, opts("Open Preview"))
		vim.keymap.set("n", "o", api.node.open.edit, opts("Open"))
		vim.keymap.set("n", "a", api.fs.create, opts("Create"))
		vim.keymap.set("n", "d", api.fs.remove, opts("Delete"))
		vim.keymap.set("n", "r", api.fs.rename, opts("Rename"))
		vim.keymap.set("n", "c", api.fs.copy.node, opts("Copy"))
		vim.keymap.set("n", "x", api.fs.cut, opts("Cut"))
		vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))

		vim.keymap.set("n", "y", api.fs.copy.filename, opts("Copy Name"))
		vim.keymap.set("n", "Y", api.fs.copy.relative_path, opts("Copy Relative Path"))
		vim.keymap.set("n", "e", api.fs.rename_basename, opts("Rename: Basename"))
		vim.keymap.set("n", "R", api.tree.reload, opts("Refresh"))
		vim.keymap.set("n", "W", api.tree.collapse_all, opts("Collapse"))
		vim.keymap.set("n", "E", api.tree.expand_all, opts("Expand All"))
	end,
}

spec.init = function()
	vim.g.loaded_netrw = 1
	vim.g.loaded_netrwPlugin = 1
end

spec.config = function(_, opts)
	require("nvim-tree").setup(opts)
	--require("nvim-tree.api").tree.open()
	--vim.cmd("wincmd p")

	vim.api.nvim_create_user_command("NvimTreeFocusToggle", function()
		if vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil then
			vim.cmd("wincmd p")
		else
			require("nvim-tree.api").tree.focus()
		end
	end, {})

	vim.api.nvim_create_user_command("NvimTreeToggle", function()
		if vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil then
			require("nvim-tree.api").tree.close()
		else
			require("nvim-tree.api").tree.focus()
		end
	end, {})
end

return loader("nvim-tree", spec)
