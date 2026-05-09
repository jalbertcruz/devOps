-- stylua: ignore start
-- if true then return {} end
-- stylua: ignore end

vim.lsp.config("lua_ls", {
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if
				path ~= vim.fn.stdpath("config")
				and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
			then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				-- Tell the language server which version of Lua you're using (most
				-- likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Tell the language server how to find Lua modules same way as Neovim
				-- (see `:h lua-module-load`)
				path = {
					"lua/?.lua",
					"lua/?/init.lua",
				},
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					-- Depending on the usage, you might want to add additional paths
					-- here.
					-- '${3rd}/luv/library',
					-- '${3rd}/busted/library',
				},
				-- Or pull in all of 'runtimepath'.
				-- NOTE: this is a lot slower and will cause issues when working on
				-- your own configuration.
				-- See https://github.com/neovim/nvim-lspconfig/issues/3189
				-- library = vim.api.nvim_get_runtime_file('', true),
			},
		})
	end,
	settings = {
		Lua = {},
	},
})

vim.lsp.enable("lua_ls")

vim.pack.add({ "git:folke/lazydev.nvim" })
require("lazydev").setup({
	library = {

		---- Library paths can be absolute
		--"~/projects/my-awesome-lib",

		-- always load the LazyVim library
		"LazyVim",

		-- It can also be a table with trigger words / mods
		-- Only load luvit types when the `vim.uv` word is found
		--{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
	},
})

P = function(v)
	print(vim.inspect(v))
	return v
end
RELOAD = function(...)
	return require("plenary.reload").reload_module(...)
end
-- 1. Manual package.loaded Removal (No Dependency)
-- Replace 'module_name' with the module you want to reload
-- package.loaded['module_name'] = nil
-- require('module_name')
-------------------------
-- 2. Recursive Module Reload
-- If you need to reload a module and all its sub-modules
-- function ReloadConfig(module_name)
--    for k, _ in pairs(package.loaded) do
--        if k:match(module_name) then
--            package.loaded[k] = nil
--        end
--    end
--    -- Optional: require("your_config_root")
-- end

R = function(name)
	RELOAD(name)
	return require(name)
end

--vim.cmd.packadd('stackmap')

local set = vim.keymap.set
local k = vim.keycode
set("n", "<leader>x", "<cmd>w<CR><cmd>source %<CR>")
set("n", "<leader>rl", ":.lua<cr>", { desc = "execute lua line" })
set("v", "<leader>rl", ":lua<cr>", { desc = "execute lua visual selection" })
set("n", "<leader>fdl", function()
	require("fzf-lua").live_grep_glob({
		cwd = vim.fn.expand("$HOME/.config/nvim-fs"),
	})
end, {
	desc = "nvim-lua files by content",
})
set("n", "<leader>fdf", function()
	require("fzf-lua").files({
		cwd = vim.fn.expand("$HOME/.config/nvim-fs"),
	})
end, {
	desc = "nvim-lua files by name",
})
