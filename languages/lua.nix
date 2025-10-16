{ pkgs, ... }:
{
  plugins.lsp.servers.lua_ls = {
    enable = true;
    settings.Lua = {
      runtime.version = "LuaJIT";
      diagnostics.globals = [ "vim" ];
      workspace = {
        library = [ "${pkgs.vimPlugins.neodev-nvim}" ];
        checkThirdParty = false;
      };
      telemetry.enable = false;
    };
  };

  plugins.conform-nvim.settings.formatters_by_ft.lua = [ "stylua" ];

  extraPackages = with pkgs; [
    lua
    stylua
  ];

  plugins.treesitter.settings.ensure_installed = [ "lua" ];
}
