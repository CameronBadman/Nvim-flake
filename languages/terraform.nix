{ pkgs, ... }:
{
  plugins.lsp.servers.terraformls = {
    enable = true;
  };

  plugins.conform-nvim.settings.formatters_by_ft.terraform = [ "terraform_fmt" ];

  extraPackages = with pkgs; [
    terraform
    terraform-ls
  ];

  plugins.treesitter.settings.ensure_installed = [ "terraform" "hcl" ];
}
