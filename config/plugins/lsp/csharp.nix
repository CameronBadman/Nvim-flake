{
  plugins.lsp.servers.omnisharp = {
    enable = true;
    settings = {
      FormattingOptions = {
        EnableEditorConfigSupport = true;
      };
      RoslynExtensionsOptions = {
        EnableAnalyzersSupport = true;
      };
    };
  };
}
