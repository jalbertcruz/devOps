local set = vim.keymap.set
local k = vim.keycode

set("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true, desc = "move down and center" })
set("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true, desc = "move up and center" })
set("n", "<C-f>", "<C-f>zz", { noremap = true, silent = true })
set("n", "<C-b>", "<C-b>zz", { noremap = true, silent = true })

set({ "n", "v" }, "<leader>tw", require("visual-whitespace").toggle, {desc = "Enable/Disable visual whitespace"})

-- vim.g["toggle_spelling"] = true
-- function toggle_spelling()
--   if vim.g.toggle_spelling then
--     vim.cmd([[
--         bufdo set nospell
--     ]])
--     vim.g.toggle_spelling = false
--     vim.lsp.enable("ltex_plus", false)
--     vim.lsp.enable("harper_ls", false)
--   else
--     vim.cmd([[
--         bufdo set spell
--     ]])
--     vim.g.toggle_spelling = true
--     vim.lsp.enable("ltex_plus", true)
--     vim.lsp.enable("harper_ls", true)
--   end
-- end

function disable_spelling()
    vim.cmd([[
        bufdo set nospell
    ]])
    vim.lsp.enable("ltex_plus", false)
    vim.lsp.enable("harper_ls", false)
end

function enable_spelling()
    vim.cmd([[
        bufdo set spell
    ]])
    vim.g.toggle_spelling = true
    vim.lsp.enable("ltex_plus", true)
    vim.lsp.enable("harper_ls", true)
end

-- set("n", "<leader>xd", Toggle_diagnostics, { noremap = true, silent = true, desc = "Toggle vim diagnostics" }) -- already present in LazyVim
-- https://neovim.io/doc/user/spell.html
set("n", "<leader>ts", disable_spelling, {
  desc = "Disable spell check",
})

set("n", "<leader>tS", enable_spelling, {
  desc = "Enable spell check",
})
-- set("n", "<leader>tsu", ":setlocal spell spelllang=en_us<cr>", {
--   desc = "Set spell check to en_us",
-- })
-- set("n", "<leader>tss", ":setlocal spell spelllang=es<cr>", {
--   desc = "Set spell check to es",
-- })
