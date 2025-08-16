{
  plugins.lsp.servers.gopls = {
    enable = true;
    settings = {
      gopls = {
        analyses = {
          unusedparams = true;
          shadow = true;
        };
        staticcheck = true;
        gofumpt = true;
      };
    };
  };
}
