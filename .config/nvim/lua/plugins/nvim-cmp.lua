return {
  'hrsh7th/nvim-cmp',
  enabled = require('plugins.nvim-lspconfig').enabled,
  event = "InsertEnter",
  dependencies = {
    -- Autocompletion
    {'hrsh7th/cmp-buffer'},       -- Optional
    {'hrsh7th/cmp-path'},         -- Optional
    {'hrsh7th/cmp-nvim-lsp'},     -- Required
    {'hrsh7th/cmp-nvim-lua'},     -- Optional

    -- Snippets
    {'L3MON4D3/LuaSnip'},             -- Required
    {'rafamadriz/friendly-snippets'}, -- Optional
  },
  opts = function()
    local cmp = require('cmp')
    return {
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end
      },
      sources = {
        {name = 'path'},
        {name = 'nvim_lsp', keyword_length = 1},
        {name = 'buffer', keyword_length = 3},
        {name = 'luasnip', keyword_length = 2},
      },
      window = {
        documentation = cmp.config.window.bordered()
      },
      formatting = {
        fields = {'menu', 'abbr', 'kind'},
        format = function(entry, item)
          local menu_icon = {
            nvim_lsp = 'λ',
            luasnip = '⋗',
            buffer = 'Ω',
            path = '🖫',
          }
          item.menu = menu_icon[entry.source.name]
          return item
        end,
      },
      mapping = {
        ['<Up>'] = cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select}),
        ['<Down>'] = cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select}),

        ['<C-p>'] = cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select}),
        ['<C-n>'] = cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select}),
        ["<C-Space>"] = cmp.mapping.complete(),

        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),

        ['<C-e>'] = cmp.mapping.abort(),
        ['<C-y>'] = cmp.mapping.confirm({select = true}),
        ['<CR>'] = cmp.mapping.confirm({select = false}),

        ['<C-f>'] = cmp.mapping(function(fallback)
          if require('luasnip').jumpable(1) then
            require('luasnip').jump(1)
          else
            fallback()
          end
        end, {'i', 's'}),

        ['<C-b>'] = cmp.mapping(function(fallback)
          if require('luasnip').jumpable(-1) then
            require('luasnip').jump(-1)
          else
            fallback()
          end
        end, {'i', 's'}),

        ['<Tab>'] = cmp.mapping(function(fallback)
          local col = vim.fn.col('.') - 1

          if cmp.visible() then
            cmp.select_next_item({behavior = cmp.SelectBehavior.Select})
          elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
            fallback()
          else
            cmp.complete()
          end
        end, {'i', 's'}),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item({behavior = cmp.SelectBehavior.Select})
          else
            fallback()
          end
        end, {'i', 's'}),
      },
    }
  end
}
