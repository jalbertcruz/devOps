-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.g["multi_line_active"] = false

local set = vim.keymap.set

set("n", "<leader><F5>", vim.cmd.UndotreeToggle)

require("config.keymaps.diagnostics")
--require("config.keymaps.fzf")
require("config.keymaps.general")
require("config.keymaps.terminal")

--vim.keymap.del("n", "<M-j>")
--vim.keymap.del("n", "<M-k>")
--vim.keymap.del("n", "<down>")
--vim.keymap.del("n", "<up>")

set("n", "ga", "<cmd>BufferLinePick<cr>", { desc = "Buffer pick" })

-- nvim development:
-- vim.keymap.set("n", "<space>xs", "<cmd>source %<CR>")
--vim.keymap.set("n", "<space>x", ":.lua<CR>")
--vim.keymap.set("v", "<space>x", ":lua<CR>")
set("n", "<leader>rr", "<cmd>source %<cr>", { desc = "source lua file" })
set("n", "<leader>rl", ":.lua<cr>", { desc = "execute lua line" })
set("v", "<leader>rl", ":lua<cr>", { desc = "execute lua visual selection" })

set("n", "<leader>fs", ":wa<CR>", { noremap = true, silent = true, desc = "save all buffers" })
set("n", "<leader>fp", "]pkdd", { noremap = true, silent = true, desc = "formated paste" })
set("n", "<leader>fP", "p^x", { noremap = true, silent = true, desc = "indented paste a non leaded spaced line" })
set("v", "<leader>fx", '"_dP', { noremap = true }) -- no yank on replace

-- Smart Python-aware paste (visual mode keeps indent)

-- vim.keymap.set('v', 'p', '"_dP', { noremap = true })  -- no yank on replace

-- vim.keymap.set('v', 'p', '+_dP', { noremap = true })  -- no yank on replace

-- vim.keymap.set('n', '<leader>fp', 'o<Esc>"*]p', { silent = true })  -- leader-p = paste+autoindent
-- https://archive.is/kXRk2#selection-755.0-775.3
-- https://levelup.gitconnected.com/top-5-neovim-remaps-c28f244639ac
vim.keymap.set("n", "Y", "y$")
-- vim.keymap.set("n", "<leader>bc", "<cmd>bp|bd #<CR>", { desc = "Close Buffer; Retain Split" })

vim.keymap.set("n", "yf", "yy")
--vim.keymap.set("i", "jw", "<Esc>", { desc = "Esc" })

--vim.keymap.set("n", "<leader>h", "<cmd>cnext<CR>zz", { desc = "Forward qfixlist" })
--vim.keymap.set("n", "<leader>;", "<cmd>cprev<CR>zz", { desc = "Backward qfixlist" })

--vim.keymap.set("n", "<leader>cf", "<cmd>let @+ = expand(\"%\")<CR>", { desc = "Copy File Name" })
--vim.keymap.set("n", "<leader>cp", "<cmd>let @+ = expand(\"%:p\")<CR>", { desc = "Copy File Path" })
