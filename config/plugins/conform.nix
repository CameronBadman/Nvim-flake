{ ... }:
{
  plugins.conform-nvim = {
    enable = true;
    settings = {
      # Global format on save behavior
      format_on_save = {
        timeout_ms = 500;
        lsp_fallback = true;
      };
    };
  };
}
