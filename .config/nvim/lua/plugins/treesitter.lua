return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = { 
      "bash", "c", "javascript", "json", "lua", "python", 
      "typescript", "tsx", "css", "rust", "java", "yaml", 
      "markdown", "markdown_inline", "hcl" 
    },
	  ignore_install = { "phpdoc" },
	  highlight = {
	  	enable = true,
	  	disable = { "css" },
	  },
	  autopairs = {
	  	enable = true,
	  },
	  indent = { enable = true, disable = { "python", "css" } },
  }
}
