-- kemaps.lua
local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

-- Modes
-- normal_mode = "n",
-- insert_mode = "i",
-- visual_mode = "v",
-- visual_block_mode = "x",
-- term_mode = "t",
-- command_mode = "c",

-- Leader
vim.api.nvim_set_keymap("n", "<leader>c", ":", { noremap = true, silent = false })
vim.api.nvim_set_keymap("n", "<leader><leader>", ":", { noremap = true, silent = false })
vim.api.nvim_set_keymap("n", "<leader>", "<nop>", opts)
vim.api.nvim_set_keymap("n", ",", "<nop>", opts)

-- Navigation
vim.api.nvim_set_keymap("n", "j", "h", opts)
vim.api.nvim_set_keymap("n", "k", "j", opts)
vim.api.nvim_set_keymap("n", "l", "k", opts)
vim.api.nvim_set_keymap("n", "ñ", "l", opts)

vim.api.nvim_set_keymap("v", "j", "h", opts)
vim.api.nvim_set_keymap("v", "k", "j", opts)
vim.api.nvim_set_keymap("v", "l", "k", opts)
vim.api.nvim_set_keymap("v", "ñ", "l", opts)

vim.api.nvim_set_keymap("x", "j", "h", opts)
vim.api.nvim_set_keymap("x", "k", "j", opts)
vim.api.nvim_set_keymap("x", "l", "k", opts)
vim.api.nvim_set_keymap("x", "ñ", "l", opts)

vim.api.nvim_set_keymap("n", "hñ", "A", opts)
vim.api.nvim_set_keymap("n", "hj", "I", opts)

-- Move
vim.keymap.set("n", "<C-j>", "<C-w><Left>", opts)
vim.keymap.set("n", "<C-k>", "<C-w><Down>", opts)
vim.keymap.set("n", "<C-l>", "<C-w><Up>", opts)
vim.keymap.set("n", "<C-ñ>", "<C-w><Right>", opts)
vim.keymap.set("n", "<F6>", "<C-w><Right>", opts)

-- Buffers
--keymap("n", "<BS>", ":bd<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>n", ":enew<cr>", opts)
vim.api.nvim_set_keymap("n", "<BS>", ":bp<bar>sp<bar>bn<bar>bd<cr>", opts)
vim.api.nvim_set_keymap("n", "<TAB>", ":bnext<cr>", opts)
vim.api.nvim_set_keymap("n", "<S-TAB>", ":bprev<cr>", opts)

-- Save files
vim.api.nvim_set_keymap("n", "<C-s>", ":w<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-x>", ":x<cr>", opts)
vim.api.nvim_set_keymap("i", "<C-s>", ":w<cr>", opts)
vim.api.nvim_set_keymap("i", "<C-x>", ":x<cr>", opts)

vim.api.nvim_set_keymap("n", "<leader>q", ":qa<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>Q", ":qa<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>w", ":silent w<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>x", ":silent x<cr>", opts)

-- Copy and paste
vim.api.nvim_set_keymap("i", "<C-p>", "<esc>pi", opts)
vim.api.nvim_set_keymap("i", "<C-y>", "<esc>yyi", opts)
vim.api.nvim_set_keymap("i", "<C-d>", "<esc>ddi", opts)

-- Escape
vim.api.nvim_set_keymap("i", "jk", "<esc>", opts)
vim.api.nvim_set_keymap("v", "jk", "<esc>", opts)
vim.api.nvim_set_keymap("c", "jk", "<esc>", opts)

-- Reload config
vim.api.nvim_set_keymap("n", "<leader>R", ":so ~/.config/nvim/init.lua<cr>", opts)

-- Splits
vim.api.nvim_set_keymap("n", "<leader>h", ":vsplit<cr><C-w><Right>", opts)
vim.api.nvim_set_keymap("n", "<leader>v", ":split<cr><C-w><Down>", opts)

-- Learn real vim
vim.api.nvim_set_keymap("n", "<Up>", "<nop>", opts)
vim.api.nvim_set_keymap("n", "<Down>", "<nop>", opts)
vim.api.nvim_set_keymap("n", "<Left>", "<nop>", opts)
vim.api.nvim_set_keymap("n", "<Right>", "<nop>", opts)
vim.api.nvim_set_keymap("n", ":", "<nop>", opts)
vim.api.nvim_set_keymap("n", "Q", "<nop>", opts)
vim.api.nvim_set_keymap("n", "q", "<nop>", opts)
vim.api.nvim_set_keymap("i", "<esc>", "<nop>", opts)
