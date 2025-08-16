{
  plugins.lsp.servers.terraformls = {
    enable = true;
    settings = {
      terraform = {
        timeout = "30s";
      };
    };
  };
}
