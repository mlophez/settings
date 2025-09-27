return {
  "neovim/nvim-lspconfig",
  lazy = false,
  --event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "aznhe21/actions-preview.nvim",
    "b0o/schemastore.nvim",
  },
  init = function()
    -- Mejor completado
    vim.opt.completeopt = { "menu", "menuone", "noselect" }

    -- PATH para node_modules y venv
    vim.env.PATH = table.concat({
      os.getenv("PWD") .. "/node_modules/.bin",
      os.getenv("PWD") .. "/.venv/bin",
      vim.env.PATH
    }, ":")
    --
  end,
  config = function()
    -- Capacidades LSP para nvim-cmp
    local capabilities = vim.tbl_deep_extend(
      "force",
      vim.lsp.protocol.make_client_capabilities(),
      (pcall(require, "cmp_nvim_lsp") and require("cmp_nvim_lsp").default_capabilities() or {})
    )

    -- Diagnósticos
    vim.diagnostic.config({
      update_in_insert = false,
      underline = true,
      virtual_text = { spacing = 4, prefix = "\u{ea71}" },
      severity_sort = true,
    })

    -- Keymaps comunes para todos los LSP
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
        local opts = { buffer = ev.buf }

        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "ca", require("actions-preview").code_actions, opts)
      end,
    })

    -- ======================
    -- Servidores LSP
    -- ======================

    -- Lua
    if vim.fn.executable("lua-language-server") == 1 then
      vim.lsp.enable('lua_ls')
      vim.lsp.config('lua_ls', {
        --capabilities = capabilities,
        settings = {
          Lua = {
            --diagnostics = { globals = { "vim" } },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
          },
        },
      })
    end

    -- Python: Pyright + Ruff
    if vim.fn.executable("pyright") == 1 then
      vim.lsp.enable('pyright')
      vim.lsp.config('pyright', {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          -- si quieres, puedes deshabilitar formateo de pyright y usar ruff_format
          client.server_capabilities.documentFormattingProvider = false
        end,
      })
    end

    --if vim.fn.executable("ruff-lsp") == 1 then
    --  vim.lsp.config('ruff_lsp', {
    --    capabilities = capabilities,
    --  })
    --end

    -- Rust
    if vim.fn.executable("rust-analyzer") == 1 then
      vim.lsp.enable('rust_analyzer')
      vim.lsp.config('rust_analyzer', {
        capabilities = capabilities,
      })
    end

    -- Go
    if vim.fn.executable("gopls") == 1 then
      vim.lsp.enable('gopls')
      vim.lsp.config('gopls', {
        capabilities = capabilities,
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        root_dir = require("lspconfig/util").root_pattern("go.work", "go.mod", ".git"),
        settings = {
          gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            analyses = { unusedparams = true },
          },
        },
      })
    end

    -- Terraform
    if vim.fn.executable("terraform-ls") == 1 then
      vim.lsp.enable('terraformls')
      vim.lsp.config('terraformls', { capabilities = capabilities })
    end

    -- Markdown
    if vim.fn.executable("marksman") == 1 then
      vim.lsp.enable('marksman')
      vim.lsp.config('marksman', { capabilities = capabilities })
    end

    -- HTML / Emmet
    if vim.fn.executable("emmet-language-server") == 1 then
      vim.lsp.enable('emmet_language_server')
      vim.lsp.config('emmet_language_server', { capabilities = capabilities })
    end

    -- CSS / Tailwind
    if vim.fn.executable("tailwindcss-language-server") == 1 then
      vim.lsp.enable('tailwindcss')
      vim.lsp.config('tailwindcss', {
        capabilities = capabilities,
        filetypes = { "astro", "django-html", "htmldjango", "html" },
      })
    end

    -- TypeScript
    if vim.fn.executable("typescript-language-server") == 1 then
      vim.lsp.enable('tsserver')
      vim.lsp.config('tsserver', { capabilities = capabilities })
    end

    -- Astro
    if vim.fn.executable("astro-ls") == 1 then
      vim.lsp.enable('astro')
      vim.lsp.config('astro', {
        capabilities = capabilities,
        init_options = {
          typescript = {
            tsdk = vim.fs.normalize("/usr/lib/node_modules/typescript/lib"),
          },
        },
      })
    end

    -- YAML
    if vim.fn.executable("yaml-language-server") == 1 then
      vim.lsp.enable('yamlls')
      vim.lsp.config('yamlls', {
        capabilities = capabilities,
        settings = {
          yaml = {
            schemas = require("schemastore").yaml.schemas(),
          },
        },
      })
    end

    -- Dart / Flutter
    if vim.fn.executable("dart") == 1 then
      vim.lsp.enable('dartls')
      vim.lsp.config('dartls', {
        capabilities = capabilities,
        cmd = { "dart", "language-server", "--protocol=lsp" },
        filetypes = { "dart" },
        root_dir = require("lspconfig/util").root_pattern("pubspec.yaml", ".git"),
      })
    end
  end,
}
