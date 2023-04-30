local env_var = "LOCAL_LAZY_VIM_GIT_SERVER_BASE_URL"
local git_server_base_url = vim.fn.getenv(env_var)
local git_url_format = "https://github.com/%s.git"
local lazyrepo = "https://github.com/folke/lazy.nvim.git"
if git_server_base_url == vim.NIL or file_path == "" then
else
  git_url_format = git_server_base_url .. "/%s.git"
  lazyrepo = git_server_base_url .. "/folke/lazy.nvim.git"
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  --local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=main", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- os.exit(0)

local check_variable = require("extras.local_lib.utils").check_variable

local spec = {
  -- add LazyVim and import its plugins
  { "LazyVim/LazyVim", import = "lazyvim.plugins" },
  { import = "plugins" },
  { import = "plugins_lps" },
}

if check_variable({ variable = "PERSONAL_PLUGINS_ACTIVE", default = false }) then
  spec = vim.list_extend(spec, { { import = "plugins_personal" } })
end

require("lazy").setup({
  spec = spec,
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  git = {
    --       url_format = "https://github.com/%s.git",
    url_format = git_url_format,
  },
  rocks = {
    enabled = false,
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
