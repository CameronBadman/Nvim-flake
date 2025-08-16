# lsp/clang.nix
{
  plugins.lsp.servers.clangd = {
    enable = true;
    cmd = [
      "clangd"
      "--background-index"
      "--clang-tidy"
      "--header-insertion=iwyu"
    ];
  };
}
