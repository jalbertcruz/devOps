vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "

local set = vim.opt
---------------- vim options  ----------------
set.relativenumber = true         -- shows relative line numbers
set.number         = true                 -- shows line numbers. Shows actual line number instead of '0' when combined with relativenumber.
set.showmatch      = true                -- show matching
set.tabstop        = 2                     -- number of columns occupied by a tab
set.shiftwidth     = 2                  -- indent corresponding to number of spaces
set.expandtab      = true
set.cursorline     = true               -- highlight current cursorline
vim.g.mapleader = ' '
vim.g.maplocalloeader = ' '
set.termguicolors = true          -- enables terminal colors
set.splitright = true             -- splits automatically go to the right
set.splitbelow = true             -- splits automatically go to the bottom
set.listchars:append "tab:» "
set.listchars:append "trail: "
set.clipboard='unnamedplus'
set.autowriteall=true
set.lazyredraw=true               -- might help speed up macros
set.laststatus=0
