{ pkgs, ... }:
{
  plugins.lsp.servers.rust_analyzer = {
    enable = true;
    installRustc = true;
    installCargo = true;
    settings = {
      cargo.allFeatures = true;
      checkOnSave = true;  # Enable check on save
      # Alternative: use check.command if you want clippy specifically
      # check.command = "clippy";
    };
  };

  plugins.conform-nvim.settings.formatters_by_ft.rust = [ "rustfmt" ];
  
  extraPackages = with pkgs; [
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
  ];

  plugins.treesitter.settings.ensure_installed = [ "rust" ];
}
