return {
	"hrsh7th/nvim-cmp",
	lazy = false,
	version = false,
	event = "InsertEnter",
	dependencies = {
		-- Autocompletion
		"hrsh7th/cmp-nvim-lsp", -- Required
		"hrsh7th/cmp-buffer", -- Optional
		"hrsh7th/cmp-path", -- Optional
		"hrsh7th/cmp-nvim-lua", -- Optional
		-- Snippets
		"L3MON4D3/LuaSnip", -- Required
		"saadparwaiz1/cmp_luasnip",
		"rafamadriz/friendly-snippets", -- Optional
	},
	config = function()
		local lspkind = {
			Namespace = "󰌗",
			Text = "󰉿",
			Method = "󰆧",
			Function = "󰆧",
			Constructor = "",
			Field = "󰜢",
			Variable = "󰀫",
			Class = "󰠱",
			Interface = "",
			Module = "",
			Property = "󰜢",
			Unit = "󰑭",
			Value = "󰎠",
			Enum = "",
			Keyword = "󰌋",
			Snippet = "",
			Color = "󰏘",
			File = "󰈚",
			Reference = "󰈇",
			Folder = "󰉋",
			EnumMember = "",
			Constant = "󰏿",
			Struct = "󰙅",
			Event = "",
			Operator = "󰆕",
			TypeParameter = "󰊄",
			Table = "",
			Object = "󰅩",
			Tag = "",
			Array = "[]",
			Boolean = "",
			Number = "",
			Null = "󰟢",
			String = "󰉿",
			Calendar = "",
			Watch = "󰥔",
			Package = "",
			Copilot = "",
			Codeium = "",
			TabNine = "",
		}
		local cmp = require("cmp")

		-- Colors --
		vim.api.nvim_set_hl(0, "CmpSel", { bg = "#abe9b3", fg = "#242633" })

		-- Snippets --
		require("luasnip.loaders.from_vscode").lazy_load()

		-- Custom Snippets --
		require("luasnip.loaders.from_vscode").lazy_load({ paths = vim.fn.stdpath("config") .. "/snippets" })

		-- Autocompletion Setup --
		require("cmp").setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			sources = {
				{ name = "path" },
				{ name = "buffer" },
				{ name = "nvim_lsp" },
				{ name = "nvim_lua" },
				{ name = "luasnip" },
			},
			view = {
				entries = "custom", -- can be "custom", "wildmenu" or "native"
			},
			completion = {
				completeopt = "menu,menuone,noinsert",
			},
			window = {
				completion = cmp.config.window.bordered({
					side_padding = 1,
					scrollbar = false,
					winhighlight = "Normal:Normal,CursorLine:CmpSel,Search:Normal",
				}),
				documentation = cmp.config.window.bordered({
					winhighlight = "Normal:Normal",
				}),
			},
			formatting = {
				--fields = { "menu", "abbr", "kind" },
				fields = { "abbr", "kind" },
				format = function(entry, item)
					item.kind = string.format("  %s %s ", lspkind[item.kind], item.kind)
					item.menu = ({
						buffer = "[BUF]",
						nvim_lsp = "[LSP]",
						luasnip = "[SNIP]",
						nvim_lua = "[LUA]",
						path = "[PATH]",
					})[entry.source.name]
					return item
				end,
			},
			mapping = {
				["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
				["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
				["<C-Space>"] = cmp.mapping.complete(),
				["<CR>"] = cmp.mapping.confirm({ select = false }),

				-- ["<Tab>"] = cmp.mapping(function(fallback)
				-- 	if cmp.visible() then
				-- 		cmp.select_next_item()
				-- 	-- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
				-- 	-- that way you will only jump inside the snippet region
				-- 	elseif luasnip.expand_or_jumpable() then
				-- 		luasnip.expand_or_jump()
				-- 	elseif has_words_before() then
				-- 		cmp.complete()
				-- 	else
				-- 		fallback()
				-- 	end
				-- end, { "i", "s" }),

				-- ["<S-Tab>"] = cmp.mapping(function(fallback)
				-- 	if cmp.visible() then
				-- 		cmp.select_prev_item()
				-- 	elseif luasnip.jumpable(-1) then
				-- 		luasnip.jump(-1)
				-- 	else
				-- 		fallback()
				-- 	end
				-- end, { "i", "s" }),

				["<Tab>"] = cmp.mapping(function(fallback)
					local col = vim.fn.col(".") - 1

					if cmp.visible() then
						cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
					elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
						fallback()
					else
						cmp.complete()
					end
				end, { "i", "s" }),

				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
					else
						fallback()
					end
				end, { "i", "s" }),
			},
		})
	end,
}
