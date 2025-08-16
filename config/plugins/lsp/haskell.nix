{
  plugins.lsp.servers.hls = {
    enable = true;
    installGhc = true;
    settings = {
      haskell = {
        cabalConfigOptions = [ ];
        checkParents = "CheckOnSave";
        checkProject = true;
        maxProblemSeverity = "Error";
      };
    };
  };
}
