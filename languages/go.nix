{ pkgs, ... }:
{
  plugins.lsp.servers.gopls = {
    enable = true;
    settings.gopls = {
      analyses = {
        unusedparams = true;
        shadow = true;
      };
      staticcheck = true;
      gofumpt = true;
    };
  };

  plugins.conform-nvim.settings.formatters_by_ft.go = [ "gofmt" "goimports" ];

  extraPackages = with pkgs; [
    go
    gotools
    gopls
  ];

  plugins.treesitter.settings.ensure_installed = [ "go" "gomod" "gowork" ];
  #plugins.neotest.adapters.go.enable = true;
  plugins.dap-go.enable = true;
}
