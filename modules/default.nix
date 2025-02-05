{ pkgs, inputs }: 
let
  languageServers = import ./language-servers.nix { inherit pkgs; };
  formatters = import ./formatters.nix { inherit pkgs; };
  utilities = import ./utilities.nix { inherit pkgs; };
  extraPlugins = import ./extra-plugins.nix { inherit pkgs inputs; };
  keymaps = import ./keymaps.nix { inherit pkgs; };
  theme = import ./theme.nix { inherit pkgs; };
in
  keymaps // theme // languageServers // formatters // utilities // extraPlugins
