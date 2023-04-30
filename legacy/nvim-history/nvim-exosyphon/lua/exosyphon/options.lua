vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.smartcase = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 20
--vim.opt.signcolumn = "yes"
vim.opt.signcolumn = "no"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
vim.opt.conceallevel = 2

vim.opt.termguicolors = true

vim.opt.foldcolumn  = "0"

-- Change cursor shape in different modes
vim.opt.guicursor = {
  "n-v-c:block",       -- Normal mode - block
  "i-ci-ve:ver25",     -- Insert mode - vertical bar
  "r-cr:hor20",        -- Replace mode - horizontal bar
  "o:hor50",           -- Operator-pending mode - horizontal bar
  "a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor", -- Blinking cursor
  "sm:block-blinkwait175-blinkoff150-blinkon175" -- Select mode - blinking block
}

