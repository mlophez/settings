return {
	"hrsh7th/nvim-cmp",
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
		-- 'rafamadriz/friendly-snippets', -- Optional
	},
	opts = function()
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
		local luasnip = require("luasnip")

		-- Colors
		vim.api.nvim_set_hl(0, "CmpSel", { bg = "#abe9b3", fg = "#242633" })

		return {
			view = {
				entries = "custom", -- can be "custom", "wildmenu" or "native"
			},
			completion = {
				completeopt = "menu,menuone,noinsert",
			},
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			sources = {
				{ name = "path" },
				{ name = "nvim_lsp", keyword_length = 1 },
				{ name = "buffer", keyword_length = 3 },
				{ name = "luasnip", keyword_length = 2 },
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
		}
	end,
}
