
vim.lsp.set_log_level("debug")

vim.lsp.config['yo_ls'] = {
  cmd = { '/opt/python-3.14.2/bin/python3', '/home/z/src/treesit/py-treesit/coordinator.py' },
  --cmd = {"/home/z/src/infra/tools/bin/private_tools/.venv/bin/phoenix-lsp"},
  -- Filetypes to automatically attach to.
  filetypes = { 'text' },
  -- Sets the "workspace" to the directory where any of these files is found.
  -- Files that share a root directory will reuse the LSP server connection.
  -- Nested lists indicate equal priority, see |vim.lsp.Config|.
  root_markers = { '.venv', '.git' },
  -- Specific settings to send to the server. The schema is server-defined.
  -- Example: https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      }
    }
  }
}

vim.lsp.enable('yo_ls')

--local client = vim.lsp.start_client {
--  name = "educationalsp",
--  cmd = {
--    "/opt/python-3.14.2/bin/python3 /home/z/src/treesit/py-treesit/coordinator.py"
--  }
--}
--
--if not client then
--  vim.notify "Hey, you didnt do the client thing good"
--  return
--end
--
--vim.api.nvim_create_autocmd("FileType", {
--  pattern = "txta",
--  callback = function()
--    vim.lsp.buf_attach_client(0, client)
--  end
--})