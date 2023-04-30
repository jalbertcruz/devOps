local M = {}

function conditional(condition, a, b)
    if condition then return a else return b end
end

-- https://www.petergundel.de/git/neovim/telescope/2023/03/22/git-jump-in-neovim-with-telescope.html
local git_hunks = function()
  require("telescope.pickers")
    .new({
      finder = require("telescope.finders").new_oneshot_job({ "git", "jump", "--stdout", "diff" }, {
        entry_maker = function(line)
          local filename, lnum_string = line:match("([^:]+):(%d+).*")

          -- I couldn't find a way to use grep in new_oneshot_job so we have to filter here.
          -- return nil if filename is /dev/null because this means the file was deleted.
          if filename:match("^/dev/null") then
            return nil
          end

          return {
            value = filename,
            display = line,
            ordinal = line,
            filename = filename,
            lnum = tonumber(lnum_string),
          }
        end,
      }),
      sorter = require("telescope.sorters").get_generic_fuzzy_sorter(),
      previewer = require("telescope.config").values.grep_previewer({}),
      results_title = "Git hunks",
      prompt_title = "Git hunks",
      layout_strategy = "flex",
    }, {})
    :find()
end

local addSelf = function()
    -- https://neovim.io/doc/user/builtin.html#feedkeys()
    -- https://neovim.io/doc/user/api.html#nvim_feedkeys()
    --vim.cmd([[
    --    :let key = nvim_replace_termcodes("]fwwaself,<Space><Esc>", v:true, v:false, v:true)
    --    :call nvim_feedkeys(key, 'x', v:false)
    --]])

    --local key = vim.api.nvim_replace_termcodes("]fwwaself,<Space><Esc>", true, false, true)
    local key = vim.api.nvim_replace_termcodes("]f", true, false, true)
    vim.api.nvim_feedkeys(key, 't', false)
end

function M.setup(opts)
   opts = opts or {}
    vim.keymap.set("n", "<Leader>gh", git_hunks, {desc = "List git hunks"})
    vim.keymap.set("n", "<Leader>3", addSelf, {})

   --vim.keymap.set("n", "<leader>h", function()
   --      print("hello: " .. vim.loop.cwd())
   --end)

    --vim.keymap.set("n", "<leader>n", function()
    --
    --    local db_path = conditional(vim.fn.isdirectory('code') ~= 0,
    --            "code/.bookmarks",
    --            ".bookmarks"
    --    )
    --
    --    vim.fn.system({
    --        "mkdir",
    --        "-p",
    --        db_path,
    --        vim.loop.cwd()
    --    })
    --
    --    local db_path = conditional(vim.fn.isdirectory('code') ~= 0, vim.fs.normalize(vim.loop.cwd() .. "/code/.bookmarks/bookmarks.db.json"),
    --            vim.fs.normalize(vim.loop.cwd() .. "/.bookmarks/bookmarks.db.json"))
    --
    --    require("bookmarks").setup( {
    --       json_db_path = db_path,
    --       signs = {
    --         mark = { icon = "", color = "grey" },
    --       },
    --     })
    --
    --    vim.keymap.set({ "n", "v" }, "mm", "<cmd>BookmarksMark<cr>", { desc = "Mark current line into active BookmarkList." })
    --    vim.keymap.set({ "n", "v" }, "mo", "<cmd>BookmarksGoto<cr>", { desc = "Go to bookmark at current active BookmarkList" })
    --    vim.keymap.set({ "n", "v" }, "ma", "<cmd>BookmarksCommands<cr>", { desc = "Find and trigger a bookmark command." })
    --    vim.keymap.set({ "n", "v" }, "mg", "<cmd>BookmarksGotoRecent<cr>", { desc = "Go to latest visited/created Bookmark" })
    --
    --    local json = require("bookmarks.json")
    --    local ok, result = pcall(json.read_or_init_json_file, db_path)
    --    if not ok then
    --        vim.notify(
    --                "Incorrect config, please check your config file at: "
    --                        .. vim.g.bookmarks_config.json_db_path
    --                        .. "\nor just remove it(all your bookmarks will disappear)",
    --                vim.log.levels.ERROR
    --        )
    --    end
    --    vim.g.bookmarks_cache = result
    --
    --    print(vim.g.bookmarks_config.json_db_path)
    --end)

    --local timer = vim.uv.new_timer()
    --timer:start(20, 2000, vim.schedule_wrap(function()
    --    if vim.fn.isdirectory('code') ~= 0 then
    --        vim.cmd('cd code')
    --    end
    --end))

    vim.defer_fn(function()
            if vim.fn.isdirectory(opts.code_dir) ~= 0 then
                --print("changing to code directory")
                vim.cmd('cd '..opts.code_dir)
            end
    end, 2000)

    --vim.keymap.set("n", "<leader>n", function()
    --end)

    --local harpoon = require("harpoon")
    --harpoon:setup()
    --vim.keymap.set("n", "<C-a>", function() harpoon:list():add() end)
    --vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
    --vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
    --vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)

end

function M.loadQuickFix()
    --print("loading quickfix")
    vim.fn.setqflist({}, ' ', {lines = vim.fn.systemlist('cat errors-l.txt')})
end

return M
