{ pkgs, ... }:
{
  plugins.lsp.servers.kotlin_language_server = {
    enable = true;
    # settings can be added here if needed
  };
  
  plugins.conform-nvim.settings.formatters_by_ft.kotlin = [ "ktlint" ];
  
  extraPackages = with pkgs; [
    kotlin
    kotlin-language-server
    ktlint
    gradle
  ];
  
  plugins.treesitter.settings.ensure_installed = [ "kotlin" ];
}
