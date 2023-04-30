
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

-- In case you don't want to use `:LazyExtras`,
-- then you need to set the option below.
vim.g.lazyvim_picker = "fzf"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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

require("lazy").setup(
        {
            {
                "LazyVim/LazyVim",
                import = "lazyvim.plugins",
            },
            --{ import = "lazyvim.plugins.extras.editor.fzf" },
            {
                import = "custom/plugins"
            },

        },

        {
            change_detection = {
                notify = false,
            },
       }
)

--vim.g.mapleader = ","

--require('lspconfig').ruff.setup {
--  init_options = {
--    settings = {
--      configurationPreference = "filesystemFirst"
--    }
--  }
--}

---------------- vim options ----------------
--set2.relativenumber = true
set.relativenumber = false
