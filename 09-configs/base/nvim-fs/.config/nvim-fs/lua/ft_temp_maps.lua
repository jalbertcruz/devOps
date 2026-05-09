local M = {}

local default_group_name = "FtTempMaps"

-- saved_maps[bufnr][mode.."|"..lhs] = previous map table or false sentinel
local saved_maps = {}

local function has_keymap_get()
  return vim.keymap and type(vim.keymap.get) == "function"
end

local function get_existing_map(bufnr, mode, lhs)
  -- Newer Neovim path: includes desc/callback reliably
  if has_keymap_get() then
    local bmaps = vim.keymap.get(mode, lhs, { buffer = bufnr })
    if bmaps and #bmaps > 0 then
      return bmaps[1]
    end

    local gmaps = vim.keymap.get(mode, lhs)
    if gmaps and #gmaps > 0 then
      return gmaps[1]
    end

    return nil
  end

  -- Older Neovim fallback (desc usually unavailable)
  for _, m in ipairs(vim.api.nvim_buf_get_keymap(bufnr, mode)) do
    if m.lhs == lhs then
      return {
        rhs = m.rhs,
        callback = m.callback,
        desc = nil,
        expr = m.expr == 1,
        noremap = m.noremap == 1,
        silent = m.silent == 1,
        nowait = m.nowait == 1,
        script = m.script == 1,
        unique = m.unique == 1,
        replace_keycodes = nil,
      }
    end
  end

  for _, m in ipairs(vim.api.nvim_get_keymap(mode)) do
    if m.lhs == lhs then
      return {
        rhs = m.rhs,
        callback = m.callback,
        desc = nil,
        expr = m.expr == 1,
        noremap = m.noremap == 1,
        silent = m.silent == 1,
        nowait = m.nowait == 1,
        script = m.script == 1,
        unique = m.unique == 1,
        replace_keycodes = nil,
      }
    end
  end

  return nil
end

local function save_previous_map(bufnr, mode, lhs)
  saved_maps[bufnr] = saved_maps[bufnr] or {}
  local key = mode .. "|" .. lhs

  if saved_maps[bufnr][key] ~= nil then
    return
  end

  local m = get_existing_map(bufnr, mode, lhs)
  if m then
    saved_maps[bufnr][key] = {
      rhs = m.rhs,
      callback = m.callback,
      desc = m.desc,
      expr = m.expr or false,
      noremap = m.noremap ~= false,
      silent = m.silent or false,
      nowait = m.nowait or false,
      script = m.script or false,
      unique = m.unique or false,
      replace_keycodes = m.replace_keycodes,
    }
  else
    -- No prior map existed
    saved_maps[bufnr][key] = false
  end
end

local function set_temp_map(bufnr, spec)
  local mode = assert(spec.mode, "ft_temp_maps: map spec missing `mode`")
  local lhs = assert(spec.lhs, "ft_temp_maps: map spec missing `lhs`")
  local rhs = assert(spec.rhs, "ft_temp_maps: map spec missing `rhs`")
  local opts = spec.opts or {}

  save_previous_map(bufnr, mode, lhs)
  vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", { buffer = bufnr }, opts))
end

local function restore_map(bufnr, mode, lhs)
  local by_buf = saved_maps[bufnr]
  if not by_buf then
    return
  end

  local key = mode .. "|" .. lhs
  local previous = by_buf[key]
  if previous == nil then
    return
  end

  -- Remove temporary map
  pcall(vim.keymap.del, mode, lhs, { buffer = bufnr })

  -- Restore original if one existed
  if previous then
    local rhs = previous.callback or previous.rhs
    local set_opts = {
      buffer = bufnr,
      desc = previous.desc,
      expr = previous.expr,
      noremap = previous.noremap,
      silent = previous.silent,
      nowait = previous.nowait,
      script = previous.script,
      unique = previous.unique,
    }
    if previous.replace_keycodes ~= nil then
      set_opts.replace_keycodes = previous.replace_keycodes
    end

    vim.keymap.set(mode, lhs, rhs, set_opts)
  end

  by_buf[key] = nil
  if next(by_buf) == nil then
    saved_maps[bufnr] = nil
  end
end

function M.setup(ft_specs, opts)
  opts = opts or {}
  ft_specs = ft_specs or {}

  local group_name = opts.group_name or default_group_name
  local group = vim.api.nvim_create_augroup(group_name, { clear = true })
  local patterns = vim.tbl_keys(ft_specs)

  if #patterns == 0 then
    return
  end

  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = patterns,
    callback = function(args)
      local bufnr = args.buf
      local ft = vim.bo[bufnr].filetype
      local maps = ft_specs[ft]
      if not maps or #maps == 0 then
        return
      end

      for _, spec in ipairs(maps) do
        set_temp_map(bufnr, spec)
      end

      -- Restore when buffer leaves window, or filetype changes away
      vim.api.nvim_create_autocmd({ "BufWinLeave", "FileType" }, {
        group = group,
        buffer = bufnr,
        once = true,
        callback = function(ev)
          if ev.event == "FileType" and vim.bo[bufnr].filetype == ft then
            return
          end

          for _, spec in ipairs(maps) do
            restore_map(bufnr, spec.mode, spec.lhs)
          end
        end,
      })
    end,
  })
end

return M

