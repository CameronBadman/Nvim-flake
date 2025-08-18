{ pkgs, ... }:
{
  plugins.lsp.servers.clangd = {
    enable = true;
    settings = {
      clangd = {
        arguments = [
          "--header-insertion=iwyu"
          "--clang-tidy"
          "--completion-style=detailed"
        ];
      };
    };
  };

  plugins.conform-nvim.settings.formatters_by_ft = {
    c = [ "clang-format" ];
    cpp = [ "clang-format" ];
  };

  extraPackages = with pkgs; [
    clang
    clang-tools
    gdb
    lldb
  ];

  plugins.treesitter.settings.ensure_installed = [ "c" "cpp" ];
  #plugins.dap.extensions.dap-lldb.enable = true;
}
