{ pkgs, ... }:
{
  plugins.lsp.servers.jdtls = {
    enable = true;
    settings = {
      java = {
        configuration.runtimes = [
          {
            name = "JavaSE-11";
            path = "${pkgs.jdk11}";
          }
          {
            name = "JavaSE-17";
            path = "${pkgs.jdk17}";
          }
        ];
      };
    };
  };

  plugins.conform-nvim.settings.formatters_by_ft.java = [ "google-java-format" ];

  extraPackages = with pkgs; [
    jdk17
    maven
    gradle
    google-java-format
  ];

  plugins.treesitter.settings.ensure_installed = [ "java" ];
  #plugins.neotest.adapters.java.enable = true;
  #plugins.dap.extensions.dap-java.enable = true;
}
