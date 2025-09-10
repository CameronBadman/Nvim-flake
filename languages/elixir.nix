{ pkgs, ... }:
{
  plugins.lsp.servers.elixirls = {
    enable = true;
  };
  
  plugins.conform-nvim.settings.formatters_by_ft.elixir = [ "mix" ];
  
  extraPackages = with pkgs; [
    elixir
    elixir-ls
  ];
  
  plugins.treesitter.settings.ensure_installed = [ "elixir" "heex" "eex" ];
  
  # Uncomment if you want to use neotest for Elixir
  # plugins.neotest.adapters.elixir = {
  #   enable = true;
  # };
  
  # Elixir debugging support
  plugins.dap = {
    enable = true;
    extensions.dap-ui.enable = true;
  };
}
