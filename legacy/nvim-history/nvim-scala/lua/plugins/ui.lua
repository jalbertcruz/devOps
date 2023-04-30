local Util = require("lazyvim.util")

-- like lazyvim.util.lualine.pretty_path but with a longer path (3 -> 6)
---@param opts? {relative: "cwd"|"root", modified_hl: string?}
local function lualine_pretty_path(opts)
  opts = vim.tbl_extend("force", {
    relative = "cwd",
    modified_hl = "Constant",
  }, opts or {})

  return function(self)
    local path = vim.fn.expand("%:p") --[[@as string]]

    if path == "" then
      return ""
    end
    local root = Util.root.get({ normalize = true })
    local cwd = Util.root.cwd()

    if opts.relative == "cwd" and path:find(cwd, 1, true) == 1 then
      path = path:sub(#cwd + 2)
    else
      path = path:sub(#root + 2)
    end

    local sep = package.config:sub(1, 1)
    local parts = vim.split(path, "[\\/]")
    if #parts > 6 then
      parts = { parts[1], parts[2], parts[3], parts[4], "…", parts[#parts - 1], parts[#parts] }
    end

    if opts.modified_hl and vim.bo.modified then
      parts[#parts] = Util.lualine.format(self, parts[#parts], opts.modified_hl)
    end

    return table.concat(parts, sep)
  end
end

return {
  {
    "catppuccin",
    opts = {
      color_overrides = {
        mocha = {
          -- base = "1e1e2e",
          base = "#1f1e22",
          mantle = "#232224",
        },
      },
    },
  },

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections.lualine_a =
        { {
          "mode",
          fmt = function(str)
            return str:sub(1, 1)
          end,
        } }
      opts.sections.lualine_c[4] = { lualine_pretty_path() }
      -- move metals status to the left
      opts.sections.lualine_z = opts.sections.lualine_y
      opts.sections.lualine_y = opts.sections.lualine_x
      opts.sections.lualine_x = { "g:metals_status" }
      -- remove dap:
      -- table.remove(opts.sections.lualine_y, 3)
    end,
  },
  {
    "rcarriga/nvim-notify",
    keys = function()
      return {}
    end,
  },

}
