local options = {
  backup = false,                          -- creates a backup file
  clipboard = "unnamedplus",               -- allows neovim to access the system clipboard
  cmdheight = 2,                           -- more space in the neovim command line for displaying messages
  completeopt = { "menuone", "noselect" }, -- mostly just for cmp
  conceallevel = 0,                        -- so that `` is visible in markdown files
  fileencoding = "utf-8",                  -- the encoding written to a file
  hlsearch = true,                         -- highlight all matches on previous search pattern
  ignorecase = true,                       -- ignore case in search patterns
  pumheight = 10,                          -- pop up menu height
  showmode = false,                        -- we don't need to see things like -- INSERT -- anymore
  showtabline = 0,                         -- always show tabs
  smartcase = true,                        -- smart case
  smartindent = true,                      -- make indenting smarter again
  splitbelow = true,                       -- force all horizontal splits to go below current window
  splitright = true,                       -- force all vertical splits to go to the right of current window
  swapfile = false,                        -- creates a swapfile
  termguicolors = true,                    -- set term gui colors (most terminals support this)
  timeoutlen = 300,                        -- time to wait for a mapped sequence to complete (in milliseconds)
  undofile = true,                         -- enable persistent undo
  updatetime = 300,                        -- faster completion (4000ms default)
  writebackup = false,                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  expandtab = true,                        -- convert tabs to spaces
  shiftwidth = 2,                          -- the number of spaces inserted for each indentation
  tabstop = 2,                             -- insert 2 spaces for a tab
  cursorline = true,                       -- highlight the current line
  number = true,                           -- set numbered lines
  relativenumber = true,                   -- set relative numbered lines
  numberwidth = 4,                         -- set number column width to 2 {default 4}
  confirm = true,
  title = true,
  guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50", -- default "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
  mouse = "",
  signcolumn = "yes",                                         -- always show the sign column, otherwise it would shift the text each time
  wrap = false,                                               -- display lines as one long line
  linebreak = true,                                           -- companion to wrap, don't split words
  scrolloff = 8,                                              -- minimal number of screen lines to keep above and below the cursor
  sidescrolloff = 8,                                          -- minimal number of screen columns either side of cursor if wrap is `false`
  guifont = "JetBrainsMono Nerd Font:h14",                    -- the font used in graphical neovim applications
  --whichwrap = "bs<>[]hl",                  -- which "horizontal" keys are allowed to travel to prev/next line
  compatible = false,
  textwidth = 120,
}

-- New plugin loader
if vim.loader and vim.fn.has("nvim-0.9.1") == 1 then
  vim.loader.enable()
end

-- Set options
for k, v in pairs(options) do
  vim.opt[k] = v
end

-- Providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

-- leader key
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Theme
vim.g.theme = "catppuccin-mocha"
