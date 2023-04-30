return {
    "L3MON4D3/LuaSnip",
	-- follow latest release.
	version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	-- install jsregexp (optional!).
	--build = "make install_jsregexp",

    config = function()

        local ls = require "luasnip"
        local types = require "luasnip.util.types"

        ls.config.set_config {
            history = true,
            updateevents = "TextChanged,TextChangedI",
            enable_autosnippets = true,
            ext_opts = {
                [types.choiceNode] = {
                    active = {
                        virt_tex = {{ "<-", "Error"}}
                    },
                },
            },
        }

        -- expansion key
        -- this will expand the current item or jump to the next item within the snippet
        --vim.keymap.set({"i", "s"}, "<C-a>", function()
        --    if ls.expand_or_jumpable() then
        --        return ls.expand_or_jump()
        --    end
        --end, {silent = true})
        --
        ---- jump backwards key
        ---- this always moves to the previous item within the snippet
        --vim.keymap.set({"i", "s"}, "<C-j>", function()
        --    if ls.jumpable(-1) then
        --        return ls.jump(-1)
        --    end
        --end, {silent = true})
        --
        ---- is selecting within a list of options
        ---- this is useful for choice nodes
        --vim.keymap.set("i", "<C-l>", function()
        --    if ls.choice_active() then
        --        return ls.change_choice(1)
        --    end
        --end, {silent = true})


        vim.keymap.set({"i"}, "<C-a>", function() ls.expand() end, {silent = true})
        vim.keymap.set({"i", "s"}, "<C-l>", function() ls.jump( 1) end, {silent = true})
        vim.keymap.set({"i", "s"}, "<C-j>", function() ls.jump(-1) end, {silent = true})

        vim.keymap.set({"i", "s"}, "<C-e>", function()
            if ls.choice_active() then
                ls.change_choice(1)
            end
        end, {silent = true})


        --vim.keymap.set("i", "<C-u>",
        --        require "luasnip.extras.select_choice"
        --)

        vim.api.nvim_set_keymap("i", "<C-n>", "<Plug>luasnip-next-choice", {})
        vim.api.nvim_set_keymap("s", "<C-n>", "<Plug>luasnip-next-choice", {})
        vim.api.nvim_set_keymap("i", "<C-p>", "<Plug>luasnip-prev-choice", {})
        vim.api.nvim_set_keymap("s", "<C-p>", "<Plug>luasnip-prev-choice", {})

        -- source the luasnips file again, to reload the snippets
        vim.keymap.set("n", "<leader><leader>s", "<CMD>source /home/a/src/devOps/setup/nvim-scala/.config/nvim/after/snippets.lua<CR>", {silent = true})

    end

}