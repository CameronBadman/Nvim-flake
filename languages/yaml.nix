{ pkgs, ... }:
{
  plugins.lsp.servers.yamlls = {
    enable = true;
    settings.yaml = {
      schemas = {
        "https://json.schemastore.org/github-workflow.json" = "/.github/workflows/*";
        "https://json.schemastore.org/kustomization.json" = "/kustomization.{yml,yaml}";
        "https://json.schemastore.org/chart.json" = "/Chart.{yml,yaml}";
      };
    };
  };

  plugins.conform-nvim.settings.formatters_by_ft.yaml = [ "prettier" ];

  extraPackages = with pkgs; [
    nodePackages.prettier
  ];

  plugins.treesitter.grammarPackages = [
    pkgs.vimPlugins.nvim-treesitter.builtGrammars.yaml
  ];
}
