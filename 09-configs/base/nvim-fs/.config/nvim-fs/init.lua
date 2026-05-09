-- nvim 0.12
-- https://neovim.io/doc/user/pack/
-- https://github.com/SvenBroeckling/nvim-0.12-config/blob/main/init.lua
-- https://www.youtube.com/watch?v=UE6XQTAxwE0
-- git:mplusp/nvim-0.12-vim-pack-intro

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

-- vim:fileencoding=utf-8:foldmethod=marker

-- [[ --------------------- KEYMAP OVERVIEW --------------------- ]]
--
-- Leader key: "," (comma)
--
-- ---------------------------------------------------------------
--  General Editor & Text
-- ---------------------------------------------------------------
--   <leader>w    (n) : Toggle word wrap ON
--   <leader>W    (n) : Toggle word wrap OFF
--   Y            (n) : Yank line (full line)
--   <C-c>        (n) : Copy current line to clipboard
--   <C-c>        (v) : Copy selection to clipboard
--   >            (v) : Indent selection
--   <            (v) : Outdent selection
--
-- ---------------------------------------------------------------
--  Window & Buffer Management
-- ---------------------------------------------------------------
--   <C-h>        (n) : Move window to far left
--   <C-l>        (n) : Move window to far right
--   gt           (n) : Go to next buffer
--   gT           (n) : Go to previous buffer
--   gb           (n) : [Telescope] Go to buffer
--   <leader>sb   (n) : [Telescope] Search buffers
--
-- ---------------------------------------------------------------
--  File & Project Navigation
-- ---------------------------------------------------------------
--   <C-n>        (n) : Toggle NvimTree file explorer
--   <M-1>        (n) : Open Oil file explorer
--   <M-2>        (n) : Open MiniFiles file explorer
--   <C-p>        (n) : [Telescope] Find files
--   <C-e>        (n) : [Telescope] Find old files (history)
--
-- ---------------------------------------------------------------
--  Telescope (Search)
-- ---------------------------------------------------------------
--   <leader>sg   (n) : Live Grep (search project text)
--   <leader>sw   (n) : Grep for word under cursor
--   <leader>sf   (n) : Search Functions (LSP)
--   <leader>sc   (n) : Search Classes (LSP)
--   <leader>sv   (n) : Search Variables (LSP)
--   <leader>ss   (n) : Search All Symbols (LSP)
--   <leader>sh   (n) : Search help tags
--   <leader>sk   (n) : Search keymaps
--
-- ---------------------------------------------------------------
--  LSP & Code (Active in code buffers)
-- ---------------------------------------------------------------
--   gd           (n) : Go to Definition
--   K            (n) : Hover documentation
--   [d           (n) : Go to previous diagnostic
--   ]d           (n) : Go to next diagnostic
--   <leader>ca   (n) : Code Actions
--   <leader>rn   (n) : Rename symbol
--   <leader>vr   (n) : View References
--   <leader>vws  (n) : View Workspace Symbols
--   <leader>lf   (n) : Format buffer (LSP)
--   <C-h>        (i) : Signature Help (in insert mode)
--
-- ---------------------------------------------------------------
--  Diagnostics & Quickfix
-- ---------------------------------------------------------------
--   <leader>ge   (n) : Jump to next diagnostic
--   <leader>gE   (n) : Jump to previous diagnostic
--   <leader>vd   (n) : Show diagnostic in float
--   <leader>sd   (n) : [Telescope] Search all diagnostics
--   <leader>x    (n) : Close quickfix window
--   <leader>sn   (n) : Next item in quickfix
--   <leader>sp   (n) : Previous item in quickfix
--   <leader>sq   (n) : [Telescope] Search quickfix list
--
-- ---------------------------------------------------------------
--  Bookmarks (bookmarks.nvim)
-- ---------------------------------------------------------------
--   <leader>ba   (n) : Add bookmark at line
--   <leader>br   (n) : Remove bookmark at line
--   <leader>bl   (n) : [Telescope] List all bookmarks
--   mn           (n) : Jump to next bookmark (plugin default)
--   mp           (n) : Jump to previous bookmark (plugin default)
--
-- [[ ----------------------------------------------------------- ]]

require("vim._core.ui2").enable({ msg = { target = "cmd" } })

-- Use system clipboard for all yank, delete, change, and put operations
vim.opt.clipboard = "unnamedplus"

vim.g.maplocalleader = ","
--: Options
-- vim.g.mapleader = ","
vim.g.mapleader = " " -- sets leader to space
vim.o.background = "dark"
vim.o.backup = false
vim.o.expandtab = true
vim.o.hlsearch = false
vim.o.incsearch = true
vim.o.number = true
vim.o.scrolloff = 8
vim.o.shiftwidth = 4
vim.o.showmode = false
vim.o.signcolumn = "yes"
vim.o.smartindent = true
vim.o.softtabstop = 4
vim.o.swapfile = false
vim.o.tabstop = 4
vim.o.termguicolors = true
vim.o.updatetime = 50
vim.o.winborder = "rounded"
vim.o.wrap = false
--:

--: Godot
-- paths to check for project.godot file
local paths_to_check = { "/", "/../" }
local is_godot_project = false
local godot_project_path = ""
local cwd = vim.fn.getcwd()

-- iterate over paths and check
for key, value in pairs(paths_to_check) do
	if vim.uv.fs_stat(cwd .. value .. "project.godot") then
		is_godot_project = true
		godot_project_path = cwd .. value
		break
	end
end

-- check if server is already running in godot project path
local is_server_running = vim.uv.fs_stat(godot_project_path .. "/server.pipe")
-- start server, if not already running
if is_godot_project and not is_server_running then
	vim.fn.serverstart(godot_project_path .. "/server.pipe")
end
--:

--: Basic keymaps
local function set_wrap()
	vim.opt.wrap = true
	vim.opt.linebreak = true
	vim.keymap.set("n", "j", "gj")
	vim.keymap.set("n", "k", "gk")
end

local function set_nowrap()
	vim.opt.wrap = false
	vim.opt.linebreak = false
	vim.keymap.set("n", "j", "j")
	vim.keymap.set("n", "k", "k")
end

vim.keymap.set("v", ">", ">gv", { noremap = true })
vim.keymap.set("v", "<", "<gv", { noremap = true })

vim.keymap.set("n", "Y", "yy")
vim.keymap.set("v", "<C-c>", '"+y')
vim.api.nvim_set_keymap(
	"n",
	"<C-c>",
	[[:lua vim.fn.setreg('+', vim.fn.getline('.'))<CR>]],
	{ noremap = true, silent = true }
)

vim.keymap.set("n", "<leader>w", set_wrap)
vim.keymap.set("n", "<leader>W", set_nowrap)

vim.keymap.set("n", "<leader>x", [[:cclose]])

vim.keymap.set("n", "<leader>ge", function()
	vim.diagnostic.jump({ count = 1 })
end)
vim.keymap.set("n", "<leader>gE", function()
	vim.diagnostic.jump({ count = -1 })
end)

vim.keymap.set("n", "<leader>sn", ":cnext<CR>", { noremap = true })
vim.keymap.set("n", "<leader>sp", ":cprev<CR>", { noremap = true })

-- Move the current window to the far left
vim.keymap.set("n", "<C-h>", "<C-W>H", { desc = "Move window to far left", noremap = true, silent = true })
-- Move the current window to the far right
vim.keymap.set("n", "<C-l>", "<C-W>L", { desc = "Move window to far right", noremap = true, silent = true })

vim.keymap.set("n", "gt", ":bn<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "gT", ":bp<CR>", { noremap = true, silent = true })
--:

--: Plugins

-- -- lua/plugins/theme.lua
-- vim.pack.add({
-- 	{ src = "git:folke/tokyonight.nvim" },
-- })
-- require("tokyonight").setup({
-- 	style = "night",
-- 	transparent = true,
-- })
-- vim.cmd("colorscheme tokyonight")

--: catppuccin
vim.pack.add({
	{ src = "git:catppuccin/nvim.git", name = "catppuccin" },
})
vim.cmd.colorscheme("catppuccin")
--:

vim.pack.add({
	{ src = "git:folke/which-key.nvim.git" },
})

--: sleuth
vim.pack.add({
	{ src = "git:tpope/vim-sleuth" },
})
--:

--: nvim-notify
vim.pack.add({
	{ src = "git:rcarriga/nvim-notify" },
	{ src = "git:MunifTanjim/nui.nvim" },
	{ src = "git:folke/noice.nvim" },
})
require("noice").setup({
	cmdline = {
		enabled = false, -- enables the Noice cmdline UI
	},
	lsp = {
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
		},
	},
	presets = {
		bottom_search = true, -- use a classic bottom cmdline for search
		command_palette = false, -- position the cmdline and popupmenu together
		long_message_to_split = true, -- long messages will be sent to a split
		inc_rename = false, -- enables an input dialog for inc-rename.nvim
		lsp_doc_border = false, -- add a border to hover docs and signature help
	},
})
--:

------------------------------------------------->>>>>>
--: lsp and mason
-- vim.pack.add({
-- 	{ src = "git:mason-org/mason.nvim.git" },
-- 	{ src = "git:mason-org/mason-lspconfig.nvim.git" },
-- 	{ src = "git:neovim/nvim-lspconfig.git" },
-- })
-- require("mason").setup()
-- require("mason-lspconfig").setup({
-- 	ensure_installed = { "lua_ls", "basedpyright", "rust_analyzer", "emmet_ls", "eslint", "ts_ls", "tailwindcss" },
-- })

-- https://github.com/fourdigits/django-template-lsp
--vim.lsp.enable({ "lua_ls", "basedpyright", "rust_analyzer", "djlsp", "gdscript" })
------------------------------------------------<<<<<<

-- vim.lsp.config("djlsp", {
-- on_attach = on_attach
-- })
-- vim.lsp.config("eslint", { on_attach = on_attach })
-- vim.lsp.config("ts_ls", { on_attach = on_attach })
-- vim.lsp.config("tailwindcss", { on_attach = on_attach })

vim.pack.add({
	{ src = "git:ibhagwan/fzf-lua" },
})

require("fzf-lua").setup({
	ui_select = true,
	-- your config here (see Configuration section below)
})
vim.keymap.set(
	"n",
	"<leader>ff",
	":lua require('fzf-lua').files()<cr>",
	{ desc = "Find files", noremap = true, silent = true }
)

vim.pack.add({
	{ src = "git:alexpasmantier/tv.nvim" },
})
require("tv").setup({
	-- your config here (see Configuration section below)
})
vim.keymap.set("n", "<leader>tf", ":Tv files<cr>", { desc = "Find files", noremap = true, silent = true })
vim.keymap.set("n", "<leader>tt", ":Tv text<cr>", { desc = "Find files", noremap = true, silent = true })

-- vim.lsp.config("emmet_ls", {
-- 	on_attach = on_attach,
-- 	filetypes = { "htmldjango", "djangohtml", "html" },
-- })
--
-- vim.lsp.config("lua_ls", { on_attach = on_attach })
-- vim.lsp.config("rust_analyzer", { on_attach = on_attach })

--:

--: nvim-tree
vim.pack.add({
	{ src = "git:nvim-tree/nvim-tree.lua" },
})

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
vim.keymap.set("n", "<C-n>", vim.cmd.NvimTreeToggle)
require("nvim-tree").setup({
	view = {
		adaptive_size = true,
	},
	update_focused_file = {
		enable = true,
	},
	sync_root_with_cwd = true,
	respect_buf_cwd = true,
})
--:

--: blink.cmp
vim.pack.add({
	{ src = "git:rafamadriz/friendly-snippets" },
})
vim.pack.add({
	{
		src = "git:saghen/blink.cmp",
		version = "v1.10.2",
	},
})

-- https://github.com/saghen/blink.cmp/blob/main/lua/blink/cmp/fuzzy/download/init.lua#L211
--  local base_url = 'https://github.com/saghen/blink.cmp/releases/download/' .. tag .. '/'
--  local base_url = 'http://localhost:3000/api/packages/saghen/generic/blink.cmp/' .. tag .. '/'
--                    https://github.com/saghen/blink.cmp/releases/download/v1.10.2/x86_64-unknown-linux-gnu.so
--              http://localhost:3000/api/packages/saghen/generic/blink.cmp/v1.10.2/x86_64-unknown-linux-gnu.so
-- https://docs.gitea.com/administration/config-cheat-sheet?_highlight=upload#repository---release-repositoryrelease
-- https://docs.gitea.com/usage/packages/generic?_highlight=release
-- GET https://gitea.example.com/api/packages/{owner}/generic/{package_name}/{package_version}/{file_name}

-- /home/z/.local/share/nvim-fs/site/pack/core/opt/blink.cmp/target/release
-- ❯ l
-- .rw-rw-r-- 2.2M z  4 Apr 23:49 -I  libblink_cmp_fuzzy.so
-- .rw-rw-r--  121 z  4 Apr 23:49 -I 󰕥 libblink_cmp_fuzzy.so.sha256
-- .rw-rw-r--    7 z  4 Apr 23:49 -I 󰡯 version
-- https://tduyng.com/blog/neovim-auto-completions/

-- Lazy load on first insert mode entry (may not necessary)
local group = vim.api.nvim_create_augroup("BlinkCmpLazyLoad", { clear = true })

vim.api.nvim_create_autocmd("InsertEnter", {
	pattern = "*",
	group = group,
	once = true,
	callback = function()
		require("blink.cmp").setup({
			keymap = { preset = "super-tab" },
			appearance = {
				nerd_font_variant = "mono",
				use_nvim_cmp_as_default = true,
			},
			completion = {
				documentation = {
					--                     auto_show = false
					auto_show = true,
				},
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
		})
	end,
})

--
-- vim.api.nvim_create_autocmd('PackChanged', { callback = function(ev)
--   local name, kind = ev.data.spec.name, ev.data.kind
--   if name == 'blink.cmp' and (kind == 'install') then
--     if not ev.data.active then vim.cmd.packadd('blink.cmp') end
-- --     vim.cmd('TSUpdate')
-- 	vim.notify("Building blink.cmp", vim.log.levels.INFO)
-- 	local obj = vim.system({ "cargo", "build", "--release" }, { cwd = params.path }):wait()
-- 	if obj.code == 0 then
-- 		vim.notify("Building blink.cmp done", vim.log.levels.INFO)
-- 	else
-- 		vim.notify("Building blink.cmp failed", vim.log.levels.ERROR)
-- 	end
--   end
-- end })

--:

-- local builtin = require('telescope.builtin')
--
-- require('telescope').setup({
-- 	pickers = {
-- 		buffers = {
-- 			initial_mode = "normal",
-- 		},
-- 		bookmarks = {
-- 			initial_mode = "normal",
-- 		},
-- 	},
-- })

-- function SearchClasses()
-- 	builtin.lsp_dynamic_workspace_symbols({
-- 		symbols = { "Class" },
-- 		prompt_title = "Search Classes"
-- 	})
-- end
--
-- function SearchFunctions()
-- 	builtin.lsp_dynamic_workspace_symbols({
-- 		symbols = { "Function", "Method" },
-- 		prompt_title = "Search Functions"
-- 	})
-- end
--
-- function SearchVariables()
-- 	builtin.lsp_dynamic_workspace_symbols({
-- 		symbols = { "Variable", "Constant" },
-- 		prompt_title = "Search Variables"
-- 	})
-- end
--
-- vim.keymap.set('n', '<C-p>', builtin.find_files, {})
-- vim.keymap.set('n', '<C-e>', builtin.oldfiles, {})
-- -- vim.keymap.set('n', '<leader>sg', builtin.git_files, {})
-- vim.keymap.set('n', '<leader>sf', SearchFunctions, {})
-- vim.keymap.set('n', '<leader>sc', SearchClasses, {})
-- vim.keymap.set('n', '<leader>sv', SearchVariables, {})
-- vim.keymap.set('n', 'gb', ":Telescope buffers<CR>", { desc = '[G]oto [B]uffer' })
-- vim.keymap.set('n', '<leader>ss', builtin.lsp_dynamic_workspace_symbols, {})
-- vim.keymap.set('n', '<leader>sg', builtin.live_grep, {})
-- vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
-- vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
-- vim.keymap.set('n', '<leader>sb', builtin.buffers, {})
-- vim.keymap.set('n', '<leader>sh', builtin.help_tags, {})
-- vim.keymap.set('n', '<leader>sq', builtin.quickfix, {})
-- vim.keymap.set('n', '<leader>sk', builtin.keymaps, {})
--:

--: conform
vim.pack.add({
	{ src = "git:stevearc/conform.nvim" },
})
require("conform").setup({
	-- 	format_on_save = {
	-- 		timeout_ms = 500,
	-- 		lsp_fallback = true,
	-- 	},
	formatters_by_ft = {
		python = {
			-- To fix auto-fixable lint errors.
			"ruff_fix",
			-- To run the Ruff formatter.
			"ruff_format",
			-- To organize the imports.
			"ruff_organize_imports",
		},
		-- 		lua = { "stylua" },
		-- 		json = { "jq" },
		-- 		rust = { "rustfmt" },
		-- 		python = { "black" },
		-- 		htmldjango = { "djlint" },
		-- 		html = { "djlint" },
		-- 		javascript = { "prettier" },
	},
})
--:

local function fallback_format(bufnr)
	bufnr = bufnr or 0

	-- Check buffer valid state
	if not vim.api.nvim_buf_is_loaded(bufnr) then
		return
	end
	if not vim.bo[bufnr].modifiable then
		return
	end
	if vim.bo[bufnr].buftype ~= "" then
		return
	end
	if vim.bo[bufnr].readonly then
		return
	end
	if vim.bo[bufnr].filetype == "" then
		return
	end
	if vim.bo[bufnr].binary then
		return
	end

	-- Now do trimming and squeezing blank lines, etc
	local with_preserved_view = require("core.utils.nvim_utils").with_preserved_view
	local utils = require("core.utils.text_manipulation")

	utils.trim_whitespace(bufnr)
	utils.squeeze_blank_lines(bufnr)

	-- Try LSP formatting if any client attached
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	if #clients > 0 then
		vim.lsp.buf.format({ bufnr = bufnr, async = false })
	else
		-- fallback manual indent reformat
		vim.api.nvim_buf_call(bufnr, function()
			with_preserved_view(function()
				vim.cmd("normal! gg=G")
			end)
		end)
	end
end

vim.keymap.set("n", "<leader>bf", function()
	require("conform").format({
		lsp_fallback = fallback_format,
		async = false,
		timeout_ms = 2000,
	})
end, { noremap = true, silent = true, desc = "Format current buffer" })

--: lualine
vim.pack.add({
	{ src = "git:nvim-lualine/lualine.nvim" },
})

require("lualine").setup({
	options = {
		theme = "auto",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = {
			{
				"branch",
				fmt = function(str)
					if #str > 5 then
						return str:sub(1, 5) .. "…"
					end
					return str
				end,
			},
			"diff",
		},
		lualine_c = {
			{
				"filename",
				path = 1,
				file_status = true,
				fmt = function(str)
					local sep = package.config:sub(1, 1) -- Get OS-specific path separator ('/' or '\')
					local parts = {}

					for part in string.gmatch(str, "([^" .. sep .. "]+)") do
						table.insert(parts, part)
					end

					-- If there's only one part (the filename), just return it
					if #parts == 1 then
						return parts[1]
					end

					local result = {}
					-- Process all parts except the last one
					for i = 1, #parts - 1 do
						-- Take the first character of the directory name
						table.insert(result, parts[i]:sub(1, 1))
					end

					-- Add the full filename (the last part)
					table.insert(result, parts[#parts])

					-- Join them all back together
					return table.concat(result, sep)
				end,
			},
		},
		lualine_x = { "diagnostics", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	tabline = {
		--lualine_a = { 'tabs' }
	},
	inactive_sections = {
		lualine_c = { { "filename", path = 1, file_status = true } },
	},
	extensions = {},
})
--:

-- --: mini files
-- vim.pack.add({
-- 	{ src = "git:echasnovski/mini.files" },
-- })
-- require('mini.files').setup()
-- vim.keymap.set('n', '<M-2>', ":lua MiniFiles.open()<cr>", {})

--: oil
vim.pack.add({
	{ src = "git:stevearc/oil.nvim.git" },
})
require("oil").setup()
vim.keymap.set("n", "<M-1>", "<CMD>Oil<CR>", {})

-- --: diffview
-- vim.pack.add({
-- 	{ src = "git:sindrets/diffview.nvim" },
-- })

--: tiny-inline-diagnostic
vim.pack.add({
	{ src = "git:rachartier/tiny-inline-diagnostic.nvim" },
})
require("tiny-inline-diagnostic").setup()
vim.diagnostic.config({
	virtual_text = false,
	jump = { on_jump = true },
})

--: bufferline
vim.pack.add({
	{ src = "git:akinsho/bufferline.nvim" },
	-- Optional, but recommended for file icons
	{ src = "git:nvim-tree/nvim-web-devicons" },
})

require("bufferline").setup({
	options = {
		mode = "buffers",
		separator_style = "thin",
		show_buffer_close_icons = true,
		show_close_icon = true,
	},
})
--:

--: bookmarks
vim.pack.add({
	{ src = "git:heilgar/bookmarks.nvim" },
	{ src = "git:kkharji/sqlite.lua" },
})

require("bookmarks").setup({
	default_mappings = true,
	db_path = vim.fn.stdpath("data") .. "/bookmarks.db",
})

-- pcall(require("telescope").load_extension, "bookmarks")

vim.keymap.set("n", "<leader>ba", "<cmd>BookmarkAdd<cr>", { desc = "Add Bookmark", noremap = true, silent = true })
vim.keymap.set(
	"n",
	"<leader>br",
	"<cmd>BookmarkRemove<cr>",
	{ desc = "Remove Bookmark", noremap = true, silent = true }
)
vim.keymap.set(
	"n",
	"<leader>bl",
	"<cmd>Bookmarks<cr>",
	{ desc = "List Bookmarks (Telescope)", noremap = true, silent = true }
)
--:

-- vim.lsp.log.set_level("debug")

vim.pack.add({
	{ src = "git:gbprod/yanky.nvim" },
})
require("yanky").setup({})
vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")

vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")
vim.keymap.set("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)")
vim.keymap.set("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)")
vim.keymap.set("n", "]P", "<Plug>(YankyPutIndentAfterLinewise)")
vim.keymap.set("n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)")

vim.keymap.set("n", ">p", "<Plug>(YankyPutIndentAfterShiftRight)")
vim.keymap.set("n", "<p", "<Plug>(YankyPutIndentAfterShiftLeft)")
vim.keymap.set("n", ">P", "<Plug>(YankyPutIndentBeforeShiftRight)")
vim.keymap.set("n", "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)")

vim.keymap.set("n", "=p", "<Plug>(YankyPutAfterFilter)")
vim.keymap.set("n", "=P", "<Plug>(YankyPutBeforeFilter)")

vim.pack.add({
	{ src = "git:MagicDuck/grug-far.nvim" },
})
require("grug-far").setup({
	engine = "astgrep",
})

vim.pack.add({
	{ src = "git:stevearc/oil.nvim" },
})

require("oil").setup({
	columns = {  },
	keymaps = {
		--["<C-h>"] = false,
		--["<M-h>"] = "actions.select_split",
	},
	view_options = {
		show_hidden = true,
	},
})
vim.keymap.set("n", "-o", "<CMD>Oil<CR>", { desc = "Open parent directory" })

vim.pack.add({
    { src = "git:mfussenegger/nvim-dap" },
    { src = "git:rcarriga/nvim-dap-ui" },
    { src = "git:thehamsta/nvim-dap-virtual-text" },
    { src = "git:nvim-neotest/nvim-nio" },
    --{ src = "git:" },
})

--require("dapui").setup()
--require("nvim-dap-virtual-text").setup()

-- incremental selection treesitter/lsp
-- The default keybindings are:
--  v_an - select parent node
--  v_in - select child node
--  v_]n - select prev node
--  v_[n - select next node
vim.keymap.set({ "n", "x", "o" }, "<A-o>" -- Alt+o
, function()
	if vim.treesitter.get_parser(nil, nil, { error = false }) then
		require("vim.treesitter._select").select_parent(vim.v.count1)
	else
		vim.lsp.buf.selection_range(vim.v.count1)
	end
end, { desc = "Select parent treesitter node or outer incremental lsp selections" })

vim.keymap.set({ "n", "x", "o" }, "<A-i>", function()
	if vim.treesitter.get_parser(nil, nil, { error = false }) then
		require("vim.treesitter._select").select_child(vim.v.count1)
	else
		vim.lsp.buf.selection_range(-vim.v.count1)
	end
end, { desc = "Select child treesitter node or inner incremental lsp selections" })

