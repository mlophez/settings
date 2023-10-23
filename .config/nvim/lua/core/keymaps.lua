-- kemaps.lua
local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

local quit = function()
	if vim.fn.confirm("Do you want to quit?", "&Yes\n&No", 2, "Question") == 1 then
		vim.cmd.quitall()
	end
end
vim.api.nvim_create_user_command("Quit", quit, {})

-- Modes
-- normal_mode = "n",
-- insert_mode = "i",
-- visual_mode = "v",
-- visual_block_mode = "x",
-- term_mode = "t",
-- command_mode = "c",

-- Leader
vim.keymap.set("n", "<leader>c", ":", { noremap = true, silent = false })
vim.keymap.set("n", "<leader><leader>", ":", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>", "<nop>", opts)
vim.keymap.set("n", ",", "<nop>", opts)

-- Navigation
vim.keymap.set("n", "j", "h", opts)
vim.keymap.set("n", "k", "j", opts)
vim.keymap.set("n", "l", "k", opts)
vim.keymap.set("n", "ñ", "l", opts)

vim.keymap.set("v", "j", "h", opts)
vim.keymap.set("v", "k", "j", opts)
vim.keymap.set("v", "l", "k", opts)
vim.keymap.set("v", "ñ", "l", opts)

vim.keymap.set("x", "j", "h", opts)
vim.keymap.set("x", "k", "j", opts)
vim.keymap.set("x", "l", "k", opts)
vim.keymap.set("x", "ñ", "l", opts)

vim.keymap.set("n", "hñ", "A", opts)
vim.keymap.set("n", "hj", "I", opts)

-- Move
vim.keymap.set("n", "<C-h>", "<C-w>w", opts)

vim.keymap.set("n", "<C-j>", "<C-w><Left>", opts)
vim.keymap.set("n", "<C-k>", "<C-w><Down>", opts)
vim.keymap.set("n", "<C-l>", "<C-w><Up>", opts)
vim.keymap.set("n", "<C-ñ>", "<C-w><Right>", opts)
vim.keymap.set("n", "<F6>", "<C-w><Right>", opts)

-- Buffers
vim.keymap.set("n", "<BS>", ":bd<cr>", opts)
vim.keymap.set("n", "<leader>n", ":enew<cr>", opts)
--vim.keymap.set("n", "<BS>", ":bp<bar>sp<bar>bn<bar>bd<cr>", opts)
vim.keymap.set("n", "<TAB>", ":bnext<cr>", opts)
vim.keymap.set("n", "<S-TAB>", ":bprev<cr>", opts)

-- Save files
vim.keymap.set("n", "<C-s>", ":w<cr>", opts)
vim.keymap.set("n", "<C-x>", ":x<cr>", opts)
vim.keymap.set("i", "<C-s>", ":w<cr>", opts)
vim.keymap.set("i", "<C-x>", ":x<cr>", opts)

--vim.keymap.set("n", "<leader>q", ":qa<cr>", opts)
vim.keymap.set("n", "<leader>q", quit, opts)
vim.keymap.set("n", "<leader>Q", ":qa<cr>", opts)
vim.keymap.set("n", "<leader>w", ":silent w<cr>", opts)
vim.keymap.set("n", "<leader>x", ":silent x<cr>", opts)

-- Copy and paste
vim.keymap.set("i", "<C-p>", "<esc>pi", opts)
vim.keymap.set("i", "<C-y>", "<esc>yyi", opts)
vim.keymap.set("i", "<C-d>", "<esc>ddi", opts)

-- Escape
vim.keymap.set("i", "jk", "<esc>", opts)
vim.keymap.set("v", "jk", "<esc>", opts)
vim.keymap.set("c", "jk", "<esc>", opts)

-- Reload config
vim.keymap.set("n", "<leader>R", ":so ~/.config/nvim/init.lua<cr>", opts)

-- Splits
vim.keymap.set("n", "<leader>h", ":vsplit<cr><C-w><Right>", opts)
vim.keymap.set("n", "<leader>v", ":split<cr><C-w><Down>", opts)

-- Learn real vim
vim.keymap.set("n", "<Up>", "<nop>", opts)
vim.keymap.set("n", "<Down>", "<nop>", opts)
vim.keymap.set("n", "<Left>", "<nop>", opts)
vim.keymap.set("n", "<Right>", "<nop>", opts)
vim.keymap.set("n", ":", "<nop>", opts)
vim.keymap.set("n", "Q", "<nop>", opts)
vim.keymap.set("n", "q", "<nop>", opts)
vim.keymap.set("i", "<esc>", "<nop>", opts)
