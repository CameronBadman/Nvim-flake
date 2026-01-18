{ ... }:
{
  plugins.conform-nvim = {
    enable = true;
    settings = {
      # Global format on save behavior
      format_on_save = {
        timeout_ms = 3000;
        lsp_fallback = true;
      };

      formatters_by_ft = {
        "_" = [ "trim_whitespace" ];
      };

      log_level = "vim.log.levels.DEBUG";
    };
  };
}
