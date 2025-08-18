{ pkgs, ... }:
{
  plugins.lsp.servers.csharp_ls = {
    enable = true;
  };

  plugins.conform-nvim.settings.formatters_by_ft.cs = [ "csharpier" ];

  extraPackages = with pkgs; [
    dotnet-sdk
    omnisharp-roslyn
  ];

  plugins.treesitter.settings.ensure_installed = [ "c_sharp" ];
  #plugins.neotest.adapters.dotnet.enable = true;
}
