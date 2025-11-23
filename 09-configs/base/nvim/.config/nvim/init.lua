-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

local function import_lua(directory)
  for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/" .. directory .. "/*.lua", true)) do
    loadfile(ft_path)()
  end
end

import_lua("extras/exporters")
import_lua("extras/formaters")
import_lua("extras/treesitter")
import_lua("extras/searchers")
import_lua("extras/lsp")

require("extras.formaters.scala.sql_doobie").setup({})
require("extras.formaters.scala.enum_scala3").setup({})

require("luasnip.loaders.from_lua").load({ paths = "./lua/extras/snippets" })

vim.keymap.set({ "i", "s" }, "<C-a>", "<Plug>luasnip-next-choice", {})
vim.keymap.set({ "i", "s" }, "<C-b>", "<Plug>luasnip-prev-choice", {})

--vim.cmd([[
--  let g:VM_maps = {}
--  let g:VM_maps["Select Cursor Down"] = '<M-j>'
--  let g:VM_maps["Select Cursor Up"]   = '<M-k>'
--  let g:VM_default_mappings = 0
--]])

local function has_file_arg()
  for i, arg in ipairs(vim.v.argv) do
    if i > 1 and not arg:match("^%-%-") and vim.fn.filereadable(arg) == 1 then
      return arg
    end
  end
  return nil
end

local function start_up_func()
  local cwd = vim.fn.getcwd()
  local files = vim.fn.globpath(cwd, "**/*", false, true)
  local file_arg = has_file_arg()

  if #files > 0 then
    vim.cmd("edit " .. files[1])
    local buf = vim.api.nvim_get_current_buf()
    if #files > 1 then
      vim.cmd("bdelete " .. buf)
      if file_arg then
        vim.cmd("edit " .. file_arg)
      end
    end
  end
end

-- vim.schedule(start_up_func)
