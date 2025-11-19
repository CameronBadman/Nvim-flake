{ pkgs, ... }:
{
  plugins.lsp.servers = {
    docker_compose_language_service = {
      enable = true;
      extraOptions = {
        settings = {
          docker-compose = {
            validate = true;
            completion = true;
            hover = true;
          };
        };
      };
    };
    
    dockerls = {
      enable = true;
      extraOptions = {
        settings = {
          docker = {
            languageserver = {
              formatter = {
                ignoreMultilineInstructions = true;
              };
            };
          };
        };
      };
    };
  };

  plugins.conform-nvim.settings.formatters_by_ft = {
    dockerfile = [ "prettier" ];
    yaml = [ "prettier" ];
  };
  
  plugins.lint = {
    enable = true;
    lintersByFt = {
      dockerfile = [ "hadolint" ];
    };
  };

  extraPackages = with pkgs; [
    docker
    hadolint
    dockerfile-language-server
    docker-compose-language-service
  ];

  plugins.treesitter.settings.ensure_installed = [ 
    "dockerfile" 
    "yaml"
  ];

  extraConfigLua = ''
    vim.filetype.add({
      extension = {
        dockerfile = "dockerfile",
      },
      filename = {
        ["Dockerfile"] = "dockerfile",
        ["Dockerfile.dev"] = "dockerfile",
        ["Dockerfile.prod"] = "dockerfile",
        ["Dockerfile.test"] = "dockerfile",
        [".dockerignore"] = "gitignore",
      },
      pattern = {
        ["Dockerfile.*"] = "dockerfile",
        [".*%.dockerfile"] = "dockerfile",
      },
    })
    
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "dockerfile", "yaml" },
      callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.expandtab = true
      end,
    })
  '';
}
