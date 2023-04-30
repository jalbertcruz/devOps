local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("lazy").setup("plugins", {
  change_detection = {
    notify = false,
  },
})

require('exosyphon.globals')
require('exosyphon.remaps')
require('exosyphon.options')
--vim.cmd("colorscheme tokyonight")
vim.cmd('hi IlluminatedWordText guibg=none gui=underline')
vim.cmd('hi IlluminatedWordRead guibg=none gui=underline')
vim.cmd('hi IlluminatedWordWrite guibg=none gui=underline')
require('nvim-highlight-colors').setup({
  enable_named_colors = false,
})

vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

-- run vimscript
--set makeprg=sbt\ compile
-- fix this: not working when only one error
vim.cmd([[
set errorformat=%A%f:%l:%c
set errorformat+=%Z%m
]])

vim.cmd [[
let &runtimepath.=','.escape("/home/a/src/Scala/teaching/demos/scala-nvim-demo/after", '\,')
]]

vim.cmd([[
set autoindent
set cindent
]])

local set = vim.opt
---------------- vim options ----------------
set.number            = true          -- shows line numbers. Shows actual line number instead of '0' when combined with relativenumber.
set.showmatch         = true          -- show matching
set.tabstop           = 2             -- number of columns occupied by a tab
set.shiftwidth        = 2             -- indent corresponding to number of spaces
set.expandtab         = true
set.cursorline        = true          -- highlight current cursorline
vim.g.maplocalloeader = ' '
set.termguicolors     = true          -- enables terminal colors
set.splitright        = true          -- splits automatically go to the right
set.splitbelow        = true          -- splits automatically go to the bottom
set.listchars:append "tab:» "
set.listchars:append "trail: "
set.clipboard='unnamedplus'
set.autowriteall      = true
set.lazyredraw        = true          -- might help speed up macros
set.laststatus        = 0

set.relativenumber = false
--vim.o.signcolumn = "no"

-- Remove or comment out this section if it exists
-- vim.api.nvim_create_autocmd("VimLeavePre", {
--   pattern = "*",
--   command = "wa",
-- })
