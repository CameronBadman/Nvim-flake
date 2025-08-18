{ pkgs, ... }:
{
  plugins.lsp.servers.pylsp = {
    enable = true;
    settings.plugins = {
      black.enabled = true;
      ruff.enabled = true;
      mypy.enabled = true;
      pylint.enabled = true;
    };
  };

  plugins.conform-nvim.settings.formatters_by_ft.python = [ "black" "isort" ];

  extraPackages = with pkgs; [
    python3
    python3Packages.black
    python3Packages.isort
    python3Packages.ruff
    python3Packages.mypy
    python3Packages.pylint
  ];

  plugins.treesitter.settings.ensure_installed = [ "python" ];
  # plugins.neotest.adapters.python = {
  #   enable = true;
  #   settings.runner = "pytest";
  # };
  plugins.dap-python.enable = true;
}
