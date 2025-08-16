{
  plugins.lsp.servers.nil_ls = {
    enable = true;
    settings = {
      "nil" = {
        formatting = {
          command = [ "nixfmt" ];
        };
      };
    };
  };
}
