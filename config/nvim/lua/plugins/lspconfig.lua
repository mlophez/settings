return {
  "neovim/nvim-lspconfig",
  lazy = false,
  --event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "aznhe21/actions-preview.nvim",
    "b0o/schemastore.nvim",
  },
  init = function()
    -- PATH para node_modules y venv
    vim.env.PATH = table.concat({
      os.getenv("PWD") .. "/node_modules/.bin",
      os.getenv("PWD") .. "/.venv/bin",
      vim.env.PATH
    }, ":")
    --
  end,
  config = function()
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

        -- gd/gD are not Neovim 0.11+ defaults, so keep them explicit
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)

        -- Code actions via actions-preview (richer UI than the default gra)
        vim.keymap.set("n", "ca", require("actions-preview").code_actions, opts)

        -- Explicit rename binding; 0.11+ ships grn as default but make it visible
        vim.keymap.set("n", "grn", vim.lsp.buf.rename, opts)

        -- NOTE: do NOT map bare "gr" here — it shadows the built-in gr* prefix
        -- (grn rename, gra code-action, grr references, gri implementation, grt type-def).
        -- Use grr for references instead.

        -- Inlay hints toggle when the server supports them
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client and client:supports_method("textDocument/inlayHint") then
          vim.keymap.set("n", "<leader>th", function()
            vim.lsp.inlay_hint.enable(
              not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }),
              { bufnr = ev.buf }
            )
          end, opts)
        end
      end,
    })

    -- ======================
    -- Servidores LSP
    -- ======================

    -- Lua
    if vim.fn.executable("lua-language-server") == 1 then
      vim.lsp.enable('lua_ls')
      vim.lsp.config('lua_ls', {
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
        on_attach = function(client, bufnr)
          -- si quieres, puedes deshabilitar formateo de pyright y usar ruff_format
          client.server_capabilities.documentFormattingProvider = false
        end,
      })
    end

    --if vim.fn.executable("ruff-lsp") == 1 then
    --  vim.lsp.config('ruff_lsp', {
    --  })
    --end

    -- Rust
    if vim.fn.executable("rust-analyzer") == 1 then
      vim.lsp.enable('rust_analyzer')
      vim.lsp.config('rust_analyzer', {
      })
    end

    -- Go
    if vim.fn.executable("gopls") == 1 then
      vim.lsp.enable('gopls')
      vim.lsp.config('gopls', {
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        root_dir = vim.fs.dirname(vim.fs.find({ "go.work", "go.mod", ".git" }, { upward = true })[1]),
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
      vim.lsp.config('terraformls', {})
    end

    -- Markdown
    if vim.fn.executable("marksman") == 1 then
      vim.lsp.enable('marksman')
      vim.lsp.config('marksman', {})
    end

    -- HTML / Emmet
    if vim.fn.executable("emmet-language-server") == 1 then
      vim.lsp.enable('emmet_language_server')
      vim.lsp.config('emmet_language_server', {})
    end

    -- CSS / Tailwind
    if vim.fn.executable("tailwindcss-language-server") == 1 then
      vim.lsp.enable('tailwindcss')
      vim.lsp.config('tailwindcss', {
        filetypes = { "astro", "django-html", "htmldjango", "html" },
      })
    end

    -- TypeScript
    if vim.fn.executable("typescript-language-server") == 1 then
      vim.lsp.enable('ts_ls')
    end

    -- Astro
    if vim.fn.executable("astro-ls") == 1 then
      vim.lsp.enable('astro')
      vim.lsp.config('astro', {
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
        settings = {
          yaml = {
            schemas = require("schemastore").yaml.schemas(),
          },
        },
      })
    end

    -- Dart / Flutter (Deshabilitado por flutter-tools.nvim)
    if vim.fn.executable("dart") == 1 then
      vim.lsp.enable('dartls')
      vim.lsp.config('dartls', {
        cmd = { "dart", "language-server", "--protocol=lsp" },
        filetypes = { "dart" },
        root_dir = vim.fs.dirname(vim.fs.find({ "pubspec.yaml", ".git" }, { upward = true })[1]),
        settings = {
          dart = {
            lineLength = 120,
          },
        },
      })
    end
  end,
}
