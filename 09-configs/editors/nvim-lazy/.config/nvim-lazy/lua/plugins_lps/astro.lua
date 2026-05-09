return {
  --{
  --  "neovim/nvim-lspconfig",
  --  opts = function(_, opts)
  --    LazyVim.extend(opts.servers.vtsls, "settings.vtsls.tsserver.globalPlugins", {
  --      {
  --        name = "@astrojs/ts-plugin",
  --        location = LazyVim.get_pkg_path("astro-language-server", "/node_modules/@astrojs/ts-plugin"),
  --        enableForWorkspaceTypeScriptVersions = true,
  --      },
  --    })
  --  end,
  --},
}
