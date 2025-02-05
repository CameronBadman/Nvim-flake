{ pkgs }: {
  extraPackages = with pkgs; [
    black
    stylua
    nodePackages.prettier
    shfmt
    nixfmt
    codespell
  ];
}
