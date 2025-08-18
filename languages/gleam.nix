{ pkgs, ... }:
{
  plugins.lsp.servers.gleam = {
    enable = true;
  };

  plugins.conform-nvim.settings.formatters_by_ft.gleam = [ "gleam" ];

  extraPackages = with pkgs; [
    gleam
    erlang
  ];

  plugins.treesitter.settings.ensure_installed = [ "gleam" ];
}
