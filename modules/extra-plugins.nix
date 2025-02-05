{ pkgs, inputs }: {
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "kubectl-nvim";
      src = inputs.kubectl-nvim;
    })
  ];
}
