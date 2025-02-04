{
  description = "My NixVim Configuration";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    kubectl-nvim = {
      url = "github:Ramilito/kubectl.nvim";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixvim, ... }@inputs:
    let 
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeManagerModules.default = { config, lib, ... }: {
        programs.nixvim = {
          enable = true;
          defaultEditor = true;
          viAlias = true;
          vimAlias = true;

          plugins = import ./plugins { inherit pkgs; };
          
          extraPackages = with pkgs; [
            gopls rust-analyzer nodePackages.typescript-language-server
            lua-language-server nil sonarlint-ls pylint shellcheck eslint
            python311Packages.pip luarocks black stylua nodePackages.prettier
            shfmt nixfmt codespell ripgrep fd wl-clipboard kubectl
            clang-tools cpplint
          ];
          
          colorschemes.kanagawa = {
            enable = true;
            theme = "wave";
            transparent = true;
          };
          
          extraPlugins = [
            (pkgs.vimUtils.buildVimPlugin {
              name = "kubectl-nvim";
              src = inputs.kubectl-nvim;
            })
          ];
          
          extraConfigLua = ''
            -- Enable transparency
            vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
            vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
            require("config")
          '';
        };
        
        xdg.configFile = {
          "nvim/lua/config" = {
            source = ./lua;
            recursive = true;
          };
        };
      };
    };
}
