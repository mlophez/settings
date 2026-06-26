return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  branch = "main",
  priority = 101,
  main = "nvim-treesitter",
  init = function()
    local ensure_installed = {
      "astro", "bash", "c", "cpp", "css",
      "dart", "go", "hcl", "html", "http",
      "java", "javascript", "json", "lua", "markdown",
      "markdown_inline", "python", "query", "rust", "sql",
      "terraform", "tsx", "typescript", "xml", "yaml",
    }

    local already_installed = require('nvim-treesitter.config').get_installed()
    local to_install = vim.iter(ensure_installed)
        :filter(function(parser)
          return not vim.tbl_contains(already_installed, parser)
        end)
        :totable()

    require('nvim-treesitter').install(to_install)

    vim.api.nvim_create_autocmd('FileType', {
      callback = function(ev)
        -- Skip highlight and folds on very large files to avoid hangs
        local max_filesize = 100 * 1024
        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(ev.buf))
        if ok and stats and stats.size > max_filesize then
          return
        end

        pcall(vim.treesitter.start)
        vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

        -- Treesitter-based folding; start unfolded so the user folds on demand
        vim.wo.foldmethod = "expr"
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo.foldenable = false
      end,
    })
  end,
}
