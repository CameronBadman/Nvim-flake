{ pkgs, ... }:
{
  plugins.lsp.servers.pylsp = {
    enable = true;
    settings.plugins = {
      black.enabled = true;
      ruff = {
        enabled = true;
        extendSelect = [ "E" "F" "W" "C90" "I" "N" "UP" "ANN" "B" "A" "COM" "C4" "DTZ" "T10" "ISC" "ICN" "PIE" "PYI" "PT" "Q" "RSE" "RET" "SLF" "SIM" "TID" "TCH" "ARG" "PTH" "ERA" "PD" "PGH" "PL" "TRY" "NPY" "RUF" ];
        lineLength = 88;
      };
      mypy = {
        enabled = true;
        strict = true;
        dmypy = false;
        live_mode = true;
      };
      pylint = {
        enabled = true;
        args = [ "--disable=C0111" "--max-line-length=88" ];
      };
      pycodestyle = {
        enabled = true;
        maxLineLength = 88;
        ignore = [ "E203" "W503" ];
      };
      pyflakes.enabled = true;
      mccabe = {
        enabled = true;
        threshold = 10;
      };
      rope_autoimport.enabled = true;
      rope_completion.enabled = true;
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
    python3Packages.pycodestyle
    python3Packages.pyflakes
    python3Packages.mccabe
    python3Packages.rope
  ];
  
  plugins.treesitter.settings.ensure_installed = [ "python" ];
  plugins.dap-python.enable = true;
}
