{
  plugins.lsp.servers.elixirls = {
    enable = true;
    settings = {
      elixirLS = {
        dialyzerEnabled = false;
        fetchDeps = false;
      };
    };
  };
}
