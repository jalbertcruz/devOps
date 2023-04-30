local function capslock_status()
  local capslock_on = vim.fn.system("xset q | grep \"Caps Lock:\" | awk '{print $4}'") == "on\n"
  if capslock_on then
    return "CapsLock: ON"
  else
    return "CapsLock: OFF"
  end
end

return {
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, { "filetype" })
      --table.insert(opts.sections.lualine_z, { capslock_status } )
    end,
  },
}
