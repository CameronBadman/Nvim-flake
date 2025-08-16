# lsp/rust.nix
{
  plugins.lsp.servers.rust_analyzer = {
    enable = true;
    installRustc = true;
    installCargo = true;
    settings = {
      "rust_analyzer" = {
        cargo = {
          allFeatures = true;
        };
        checkOnSave = {
          command = "clippy";
        };
        procMacro = {
          enable = true;
        };
      };
    };
  };
}
