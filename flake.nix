{
  description = "My NixVim Configuration";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    kubectl-nvim = {
      url = "github:Ramilito/kubectl.nvim";
      flake = false;
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixvim, home-manager, ... }@inputs:
    let 
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      
      # Common nixvim config to avoid duplication
      commonConfig = {
        globals.mapleader = " ";  # Set leader key

keymaps = [
    {
      mode = "n";
      key = "<leader>e";
      action = ":Neotree focus<CR>";
      options = {
        silent = true;
        desc = "Open and focus Neotree";
      };
    }
  ];
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
        '';
      };
    in {
      homeManagerModules.default = { config, lib, ... }: {
        programs.nixvim = commonConfig // {
          enable = true;
          defaultEditor = true;
          viAlias = true;
          vimAlias = true;
        };
      };

      packages.${system}.default = nixvim.legacyPackages.${system}.makeNixvim (commonConfig // {
        viAlias = true;
        vimAlias = true;
      });

      homeConfigurations.test = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          self.homeManagerModules.default
        ];
      };
    };
}
