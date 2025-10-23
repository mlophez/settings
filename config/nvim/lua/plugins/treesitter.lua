return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
  branch = "master",
  version = false, -- last release is way too old and doesn't work on Windows
	build = ":TSUpdate",
	priority = 101,
  main = "nvim-treesitter.configs",
	opts = {
		sync_install = false,
		auto_install = true,

		highlight = {
			enable = true,
      -- use_languagetree = true,
			-- disable = { "css" },
      -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
      disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
              return true
          end
      end,
		},
    indent = { enable = true },
    folds = { enable = true },

		ignore_install = { "phpdoc" },
    ensure_installed = {
      "astro",       "bash",      "c",         "cpp",       "css",
      "dart",        "go",        "hcl",       "html",      "http",
      "java",        "javascript","json",      "lua",       "markdown",
      "markdown_inline","python", "query",     "rust",      "sql",
      "terraform",   "tsx",       "typescript","xml",       "yaml",
    },
	},
}
