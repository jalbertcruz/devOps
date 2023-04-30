-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

local function fix_html()
  -- Iterate over all open buffers
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    -- Check if the buffer is loaded
    if vim.api.nvim_buf_is_loaded(bufnr) then
      -- Make the buffer modifiable
      vim.api.nvim_buf_set_option(bufnr, "modifiable", true)

      -- Run the substitute command on the buffer
      vim.api.nvim_buf_call(bufnr, function()
        --vim.cmd('%s/old_text/new_text/g')
        local status, err = pcall(function()
          vim.cmd("%s/&amp;/&/g")
        end)

        local status, err = pcall(function()
          vim.cmd("%s/&lt;/</g")
        end)

        local status, err = pcall(function()
          vim.cmd("%s/&gt;/>/g")
        end)

        local status, err = pcall(function()
          vim.cmd("write")
        end)

        --if not status then
        --    print("Caught an error: " .. err)
        --else
        --    print("Command executed successfully")
        --end
      end)
    end
  end
end

vim.api.nvim_create_user_command("FixHtmlFiles", fix_html, {})

local function open_html_files_from_clipboard()
  -- Get the directory path from the system clipboard
  local directory = vim.fn.getreg("+")
  -- Get a list of all HTML files in the specified directory
  -- directory can have spaces (' '), but can not have commas (',') in it
  local html_files = vim.fn.globpath(directory, "*.html", false, true)
  -- Iterate over the list of HTML files and open each one as a buffer
  for _, file in ipairs(html_files) do
    vim.cmd("edit " .. file)
  end
end

vim.api.nvim_create_user_command("OpenHtmlFiles", open_html_files_from_clipboard, {})

-- Function to export all buffer marks and global marks to a file specified by an environment variable in JSON format
local function export_all_marks_json()
  local env_var = "MARKS_FILE_PATH"
  local file_path = vim.fn.getenv(env_var)
  if file_path == vim.NIL or file_path == "" then
    print("Environment variable " .. env_var .. " is not set or empty")
    return
  end

  local file = io.open(file_path, "w")
  if not file then
    print("Failed to open marks file: " .. file_path)
    return
  end

  local marks_data = {}

  -- Export global marks
  local global_marks = vim.fn.getmarklist()
  for _, mark in ipairs(global_marks) do
    table.insert(marks_data, {
      mark = mark.mark,
      line = mark.pos[2],
      column = mark.pos[3],
      file = mark.file,
    })
  end

  -- Export buffer marks
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    local buffer_marks = vim.fn.getmarklist(bufnr)
    for _, mark in ipairs(buffer_marks) do
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      table.insert(marks_data, {
        mark = mark.mark,
        line = mark.pos[2],
        column = mark.pos[3],
        file = bufname,
      })
    end
  end

  file:write(vim.fn.json_encode(marks_data))
  file:close()
  print("All marks exported to: " .. file_path)
end

-- Create a custom command to export all marks
vim.api.nvim_create_user_command("ExportAllMarksJson", export_all_marks_json, {})

local function clear_marks()
  local marks = vim.fn.getmarklist()
  for _, mark in ipairs(marks) do
    local status, err = pcall(function()
      vim.cmd("delmarks " .. mark.mark)
    end)
  end

  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    local status, err = pcall(function()
      vim.api.nvim_set_current_buf(bufnr)
    end)
    local function remove_first_char_if(str)
      if str:sub(1, 1) == "'" and str ~= "'" then
        return str:sub(2)
      else
        return str
      end
    end
    local buffer_marks = vim.fn.getmarklist(bufnr)
    for _, mark in ipairs(buffer_marks) do
      local status, err = pcall(function()
        vim.cmd("delmarks " .. remove_first_char_if(mark.mark))
      end)
    end
  end
  --print "All marks cleared"
end

-- Create a custom command to clear marks
vim.api.nvim_create_user_command("ClearMarks", clear_marks, {})

--vim.fn.setpos("'a", {vim.api.nvim_get_current_buf(), 11, 1, 0})

-- Function to import all buffer marks and global marks from a file specified by an environment variable in JSON format
local function import_all_marks_json()
  local env_var = "MARKS_FILE_PATH"
  local file_path = vim.fn.getenv(env_var)
  if file_path == vim.NIL or file_path == "" then
    print("Environment variable " .. env_var .. " is not set or empty")
    return
  end

  local file = io.open(file_path, "r")
  if not file then
    print("Failed to open marks file: " .. file_path)
    return
  end

  local content = file:read("*a")
  file:close()

  local marks_data = vim.fn.json_decode(content)
  if not marks_data then
    print("Failed to decode JSON from marks file: " .. file_path)
    return
  end

  local opened_buffers = {}

  for _, mark in ipairs(marks_data) do
    if mark.file and vim.loop.fs_stat(mark.file) ~= nil then
      if not opened_buffers[mark.file] then
        vim.cmd("edit " .. mark.file)
        opened_buffers[mark.file] = vim.api.nvim_get_current_buf()
      end
      local bufnr = opened_buffers[mark.file]

      local status, err = pcall(function()
        vim.fn.setpos(mark.mark, { bufnr, mark.line, mark.column, 0 })
      end)

      if not status then
        print("Caught an error: " .. err)
      end
    end
  end

  print("Marks imported from: " .. file_path)
end

-- Create a custom command to import all marks
vim.api.nvim_create_user_command("ImportAllMarksJson", import_all_marks_json, {})

local function export_keymaps_to_json()
  local env_var = "KEYMAPS_FILE_PATH"
  local file_path = vim.fn.getenv(env_var)
  if file_path == vim.NIL or file_path == "" then
    print("Environment variable " .. env_var .. " is not set or empty")
    return
  end

  local file = io.open(file_path, "w")
  if not file then
    print("Failed to open keymaps file: " .. file_path)
    return
  end

  local marks_data = {}
  local modes = { "n", "i", "v", "c", "t" }
  for _, mode in ipairs(modes) do
    local _m = {}
    local keymaps = vim.api.nvim_get_keymap(mode)
    for _, keymap in ipairs(keymaps) do
      table.insert(_m, {
        lhs = string.format("%s", keymap.lhs),
        rhs = string.format("%s", keymap.rhs),
        desc = string.format("%s", keymap.desc),
      })
    end
    table.insert(marks_data, {
      values = _m,
    })
  end

  file:write(vim.fn.json_encode(marks_data))
  file:close()

  print("Keymaps exported to: " .. file_path)
end

vim.api.nvim_create_user_command("ExportKeymapsJson", export_keymaps_to_json, {})

vim.api.nvim_create_user_command("SaveCursorPos", function()
  -- Get the full path of the current buffer
  local file_path = vim.fn.expand("%:p")

  -- Get the current cursor position (line and column)
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local line = cursor_pos[1]
  local column = cursor_pos[2]

  -- Append the line and column to the file path
  local result = string.format("%s:%d:%d", file_path, line, column)

  -- Save the result to the clipboard
  vim.fn.setreg("+", result)

  -- Print the result to confirm
  print("Saved to clipboard: " .. result)
end, {})

vim.api.nvim_create_user_command("OpenFileAtCursorPos", function()
  -- Get the content from the clipboard
  --local clipboard_content = vim.fn.getreg('+')

  -- Parse the file path, line, and column from the clipboard content
  vim.fn.getreg("+"):match("^.+:$")
  --local file_path, line, column = vim.fn.getreg('+'):match("^.+:(%d+):(%d+)$")
  --line = tonumber(line)
  --column = tonumber(column)
  --print(clipboard_content)
  --print(file_path)
  --print(line)
  --print(column)

  --if file_path and line and column then
  --  -- Open the file in a buffer
  --  vim.cmd('edit ' .. file_path)
  --
  --  -- Move the cursor to the specified position
  --  vim.api.nvim_win_set_cursor(0, {line, column})
  --else
  --  print("Invalid clipboard content. Expected format: <file_path>:<line>:<column>")
  --end
end, {})
