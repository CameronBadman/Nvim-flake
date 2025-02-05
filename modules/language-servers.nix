{ pkgs }: {
  extraPackages = with pkgs; [
    gopls
    rust-analyzer
    nodePackages.typescript-language-server
    lua-language-server
    nil
    sonarlint-ls
    pylint
    shellcheck
    eslint
    clang-tools
  ];
}
