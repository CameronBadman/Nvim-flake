{ pkgs, ... }:
{
  plugins.treesitter = {
    enable = true;
    grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
    settings = {
      highlight.enable = true;
      indent.enable = true;
      auto_install = false;
      sync_install = false;
    };
  };
}
