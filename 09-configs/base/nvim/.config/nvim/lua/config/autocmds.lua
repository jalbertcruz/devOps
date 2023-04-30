-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
-- Disable autoformat for lua files

-- vim.api.nvim_create_autocmd({ "FileType" }, {
--   pattern = { "python", "scala" },
--   callback = function()
--     vim.b.autoformat = false
--   end,
-- })

local set = vim.keymap.set
local k = vim.keycode

--local function on_buffer_event(event)
--  local buffer_ids = vim.api.nvim_list_bufs()
--
--  for index = 1, #buffer_ids - 1 do
--    set(
--      "n",
--      "<leader>b" .. index,
--      "<cmd>:BufferLineGoToBuffer " .. index .. "<cr>",
--      { noremap = true, silent = true, desc = "go to buffer " .. index }
--    )
--  end
--end
--
---- Set up autocommands for buffer creation and deletion
--vim.api.nvim_create_autocmd("BufAdd", {
--  callback = function()
--    on_buffer_event("created")
--  end,
--})
--
--vim.api.nvim_create_autocmd("BufDelete", {
--  callback = function()
--    on_buffer_event("deleted")
--  end,
--})

--local function update_lualine()
--  require('lualine').refresh()
--end
--
---- Set up autocommand for keypress
--vim.api.nvim_create_autocmd("InsertCharPre", {
--  pattern = "*",
--  callback = update_lualine,
--})

--function _G.set_terminal_keymaps()
--  local opts = { buffer = 0 }
--  vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
--  vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
--  vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
--  vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
--  vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
--  vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
--  vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
--end
--
---- if you only want these mappings for toggle term use term://*toggleterm#* instead
--vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

function set_file_type()
  -- TODO: use fzf to select from list of known filetypes
  vim.ui.input({ prompt = "Enter filetype: " }, function(input)
    if input and input ~= "" then
      vim.bo.filetype = input
    end
  end)
end

vim.api.nvim_create_user_command("Sftype", set_file_type, {})

require("config.extras_lsp")
