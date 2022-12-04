-- kemaps.lua
local opts = { noremap = true, silent = true }
local term_opts = { silent = true }
local keymap = vim.api.nvim_set_keymap

-- Modes
-- normal_mode = "n",
-- insert_mode = "i",
-- visual_mode = "v",
-- visual_block_mode = "x",
-- term_mode = "t",
-- command_mode = "c",

-- Leader
vim.g.mapleader = ","
vim.g.maplocalleader = ","
keymap("n", "<leader><leader>", ":", { noremap = true, silent = false })

-- Navigation
keymap("n", "j", "h", opts)
keymap("n", "k", "j", opts)
keymap("n", "l", "k", opts)
keymap("n", "ñ", "l", opts)

keymap("v", "j", "h", opts)
keymap("v", "k", "j", opts)
keymap("v", "l", "k", opts)
keymap("v", "ñ", "l", opts)

keymap("x", "j", "h", opts)
keymap("x", "k", "j", opts)
keymap("x", "l", "k", opts)
keymap("x", "ñ", "l", opts)

keymap("n", "hñ", "A", opts)
keymap("n", "hj", "I", opts)

-- Buffers
--keymap("n", "<BS>", ":bd<cr>", opts)
keymap("n", "<BS>", ":bp<bar>sp<bar>bn<bar>bd<cr>", opts)
keymap("n", "<TAB>", ":bnext<cr>", opts)
keymap("n", "<S-TAB>", ":bprev<cr>", opts)

-- Learn real vim
keymap("n", "<Up>", "<nop>", opts)
keymap("n", "<Down>", "<nop>", opts)
keymap("n", "<Left>", "<nop>", opts)
keymap("n", "<Right>", "<nop>", opts)
keymap("n", ":", "<nop>", opts)
keymap("n", "Q", "<nop>", opts)
keymap("n", "q", "<nop>", opts)
keymap("i", "<esc>", "<nop>", opts)

-- Save files
keymap("n", "<C-s>", ":w<cr>", opts)
keymap("n", "<C-x>", ":x<cr>", opts)
keymap("i", "<C-s>", ":w<cr>", opts)
keymap("i", "<C-x>", ":x<cr>", opts)

keymap("n", "<leader>q", ":q<cr>", opts)
keymap("n", "<leader>Q", ":q<cr>", opts)
keymap("n", "<leader>w", ":w<cr>", opts)
keymap("n", "<leader>x", ":x<cr>", opts)

-- Copy and paste
keymap("i", "<C-p>", "<esc>pi", opts)
keymap("i", "<C-y>", "<esc>yyi", opts)
keymap("i", "<C-d>", "<esc>ddi", opts)

-- Escape
--keymap("t", "<Esc>", "<C-\><C-n>", opts)
--keymap("t", "jk", "<C-\><C-n>", opts)
keymap("i", "jk", "<esc>", opts)
keymap("v", "jk", "<esc>", opts)
keymap("c", "jk", "<esc>", opts)

-- Reload config
keymap("n", "<leader>R", ":so ~/.config/nvim/init.lua<cr>", opts)

-- Splits
keymap("n", "<leader>h", ":vsplit<cr><C-w><Right>", opts)
keymap("n", "<leader>v", ":split<cr><C-w><Down>", opts)

keymap("n", "<leader>j", "<C-w><Left>", opts)
keymap("n", "<leader>k", "<C-w><Down>", opts)
keymap("n", "<leader>l", "<C-w><Up>", opts)
keymap("n", "<leader>ñ", "<C-w><Right>", opts)

--nnoremap <leader><Left> <C-w><Left>
--nnoremap <leader><Down> <C-w><Down>
--nnoremap <leader><Up> <C-w><Up>
--nnoremap <leader><Right> <C-w><Right>




