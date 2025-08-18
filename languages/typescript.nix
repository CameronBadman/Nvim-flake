{ pkgs, ... }:
{
  plugins.lsp.servers = {
    ts_ls.enable = true;
    eslint.enable = true;
  };

  plugins.conform-nvim.settings.formatters_by_ft = {
    typescript = [ "prettier" ];
    javascript = [ "prettier" ];
  };

  extraPackages = with pkgs; [
    nodejs
    nodePackages.prettier
    nodePackages.eslint
  ];

  plugins.treesitter.settings.ensure_installed = [ 
    "typescript" "javascript" "tsx" 
  ];

  #plugins.neotest.adapters.jest.enable = true;
}

