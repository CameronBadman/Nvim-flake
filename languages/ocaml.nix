{ pkgs, ... }:
{
  plugins.lsp.servers.ocamllsp = {
    enable = true;
  };

  plugins.conform-nvim.settings.formatters_by_ft.ocaml = [ "ocamlformat" ];

  extraPackages = with pkgs; [
    ocaml
    dune_3
    ocamlPackages.ocaml-lsp
    ocamlPackages.ocamlformat
  ];

  plugins.treesitter.grammarPackages = [
    pkgs.vimPlugins.nvim-treesitter.builtGrammars.ocaml
  ];
}

