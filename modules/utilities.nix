{ pkgs }: {
  extraPackages = with pkgs; [
    python311Packages.pip
    luarocks
    ripgrep
    fd
    wl-clipboard
    kubectl
    cpplint
  ];
}
