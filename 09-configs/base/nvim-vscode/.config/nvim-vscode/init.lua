
if vim.g.vscode then
    -- VSCode extension
    local vscode = require('vscode')
    vim.notify = vscode.notify
    vim.notify("hello!")
else
    -- ordinary Neovim
end
