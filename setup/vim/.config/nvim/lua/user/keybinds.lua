function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- vim config
map("n","<leader>E", ":source $HOME/.config/nvim/init.lua<cr>")

-- window navigation
--map("n", "<C-j>", "<C-w>j")
--map("n", "<C-k>", "<C-w>k")
--map("n", "<C-h>", "<C-w>h")
--map("n", "<C-l>", "<C-w>l")
--map("n", "<Leader>th", "<C-w>t<C-w>H")
--map("n", "<Leader>tk", "<C-w>t<C-w>K")


if vim.g.vscode then
    -- VSCode extension

    --nnoremap <silent> <C-j> :call VSCodeNotify('workbench.action.navigateDown')<CR>
    --xnoremap <silent> <C-j> :call VSCodeNotify('workbench.action.navigateDown')<CR>
    --nnoremap <silent> <C-k> :call VSCodeNotify('workbench.action.navigateUp')<CR>
    --xnoremap <silent> <C-k> :call VSCodeNotify('workbench.action.navigateUp')<CR>
    --nnoremap <silent> <C-h> :call VSCodeNotify('workbench.action.navigateLeft')<CR>
    --xnoremap <silent> <C-h> :call VSCodeNotify('workbench.action.navigateLeft')<CR>
    --nnoremap <silent> <C-l> :call VSCodeNotify('workbench.action.navigateRight')<CR>
    --xnoremap <silent> <C-l> :call VSCodeNotify('workbench.action.navigateRight')<CR>

    function whichkey_show() vim.fn.VSCodeNotify("whichkey.show") end
    vim.keymap.set("n", "<Space>", whichkey_show)
    vim.keymap.set("v", "<Space>", whichkey_show)


    --map("n", "<C-j>", "<C-w>j")

else
    -- ordinary Neovim
end

function FeedKeysCorrectly(keys)
    local feedablekeys = vim.api.nvim_replace_termcodes(keys, true, false, true)
    vim.api.nvim_feedkeys(feedablekeys, "n", true)
end

-- Custom text objects
function textObj()
    --vim.api.nvim_command("normal Vjj")
    vim.cmd("normal Vjjjj")
    print("toerueorteur")
end

vim.keymap.set("o", "i<Space>", textObj)

-- break the habit
map("n", "<Up>",    "<NOP>")
map("n", "<Down>",  "<NOP>")
map("n", "<Left>",  "<NOP>")
map("n", "<Right>", "<NOP>")
map("i", "<Up>",    "<NOP>")
map("i", "<Down>",  "<NOP>")
map("i", "<Left>",  "<NOP>")
map("i", "<Right>", "<NOP>")

