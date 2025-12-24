{ pkgs, ... }:
{
  plugins.lsp.servers.jsonls = {
    enable = true;
    settings = {
      json = {
        schemas = [
          {
            fileMatch = [ "package.json" ];
            url = "https://json.schemastore.org/package.json";
          }
          {
            fileMatch = [ "tsconfig*.json" ];
            url = "https://json.schemastore.org/tsconfig.json";
          }
        ];
      };
    };
  };

  plugins.conform-nvim.settings.formatters_by_ft.json = [ "prettier" ];

  extraPackages = with pkgs; [
    nodePackages.prettier
  ];

  plugins.treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
    json
    jsonc
  ];
}
