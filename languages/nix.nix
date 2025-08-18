{ pkgs, ... }:
{
  plugins.lsp.servers.nixd = {
    enable = true;
    settings.nixd = {
      nixpkgs.expr = "import <nixpkgs> { }";
      formatting.command = [ "nixfmt" ];
    };
  };

  plugins.conform-nvim.settings.formatters_by_ft.nix = [ "nixfmt" ];

  extraPackages = with pkgs; [
    nixd
    nixfmt-rfc-style
  ];

  plugins.treesitter.settings.ensure_installed = [ "nix" ];
}
