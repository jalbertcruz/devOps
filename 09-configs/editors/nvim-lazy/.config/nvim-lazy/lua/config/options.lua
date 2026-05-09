-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_python_ruff = "ruff"
vim.g.lazyvim_picker = "fzf"
-- vim.g.lazyvim_picker = "snacks"
vim.g.lazyvim_blink_main = false

-- Enable this option to avoid conflicts with Prettier.
-- if biome is enabled
vim.g.lazyvim_prettier_needs_config = false -- false if prettier

--vim.opt.spell = false

---- What is used when I type: gw
-- vim.o.textwidth = 100
-- vim.opt.clipboard = ""

-- LazyVim auto format
vim.g.autoformat = false

-- Configuration using vim.g (recommended approach)
vim.g.telescope_alternate = {
  mappings = {
    {
      "(.*)/models/(.*).py",
      {
        { "[1]/tests/*[2].py", "Test case" }, -- Adding label to switch
        --       { 'app/models/**/*[1].rb', 'Model', true }, -- Ignore create entry (with true)
      },
    },
  },
  --   presets = { 'rails', 'rspec', 'nestjs', 'angular' }, -- Pre-defined mapping presets
  picker = "fzf-lua",
  open_only_one_with = "current_pane", -- when just have only possible file, open it with.  Can also be horizontal_split and vertical_split
  --   transformers = { -- custom transformers
  --     change_to_uppercase = function(w) return my_uppercase_method(w) end
  --   },
  telescope_mappings = { -- Change the telescope mappings
    i = {
      open_current = "<CR>",
      open_horizontal = "<C-s>",
      open_vertical = "<C-v>",
      open_tab = "<C-t>",
    },
    n = {
      open_current = "<CR>",
      open_horizontal = "<C-s>",
      open_vertical = "<C-v>",
      open_tab = "<C-t>",
    },
  },
}

vim.keymap.set("n", "<leader>ta", ":TelescopeAlternate<CR>", { desc = "Alternate file" })

-- vim.api.nvim_create_autocmd("LspAttach", {
--   callback = function(args)
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     if not client then
--       return
--     else
--       client.request = require("lspfuzzy").wrap_request(client.request)
--     end
--   end,
-- })
