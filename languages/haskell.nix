{ pkgs, ... }:
{
  plugins.lsp.servers.hls = {
    enable = true;
    installGhc = false;
    settings = {
      haskell = {
        cabalFormattingProvider = "cabalfmt";
        formattingProvider = "ormolu";
      };
    };
  };

  plugins.conform-nvim.settings.formatters_by_ft.haskell = [ "ormolu" ];

  extraPackages = with pkgs; [
    ghc
    cabal-install
    stack
    haskell-language-server
    ormolu
    hlint
    haskellPackages.cabal-fmt
  ];

  plugins.treesitter.settings.ensure_installed = [ "haskell" ];
  #plugins.neotest.adapters.haskell.enable = true;
}
