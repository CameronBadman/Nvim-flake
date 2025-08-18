{ pkgs, ... }:
{
  plugins.lsp.servers.dockerls = {
    enable = true;
  };

  plugins.conform-nvim.settings.formatters_by_ft.dockerfile = [ "prettier" ];

  extraPackages = with pkgs; [
    docker
    hadolint
  ];

  plugins.treesitter.settings.ensure_installed = [ "dockerfile" ];
}
