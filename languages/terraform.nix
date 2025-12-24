{ pkgs, ... }:
{
  plugins.lsp.servers = {
    terraformls = {
      enable = true;
      extraOptions = {
        settings = {
          terraform = {
            timeout = "30s";
          };
          terraform-ls = {
            experimentalFeatures = {
              validateOnSave = true;
              prefillRequiredFields = true;
            };
          };
        };
      };
    };
    
    tflint = {
      enable = true;
      extraOptions = {
        settings = {
          tflint = {
            enabled = true;
            linters = {
              terraform_deprecated_interpolation = {
                enabled = true;
              };
              terraform_deprecated_index = {
                enabled = true;
              };
              terraform_unused_declarations = {
                enabled = true;
              };
              terraform_comment_syntax = {
                enabled = true;
              };
              terraform_documented_outputs = {
                enabled = true;
              };
              terraform_documented_variables = {
                enabled = true;
              };
              terraform_typed_variables = {
                enabled = true;
              };
              terraform_module_pinned_source = {
                enabled = true;
              };
              terraform_naming_convention = {
                enabled = true;
              };
              terraform_required_version = {
                enabled = true;
              };
              terraform_required_providers = {
                enabled = true;
              };
              terraform_standard_module_structure = {
                enabled = true;
              };
              terraform_workspace_remote = {
                enabled = true;
              };
            };
          };
        };
      };
    };
  };
  
  plugins.conform-nvim.settings.formatters_by_ft = {
    terraform = [ "terraform_fmt" ];
    tf = [ "terraform_fmt" ];
    hcl = [ "terraform_fmt" ];
  };
  
  plugins.lint = {
    enable = true;
    lintersByFt = {
      terraform = [ "tflint" ];
      tf = [ "tflint" ];
    };
  };
  
  extraPackages = with pkgs; [
    terraform
    terraform-ls
    tflint
  ];
  
  plugins.treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
    terraform
    hcl
  ];
  
  extraConfigLua = ''
    vim.filetype.add({
      extension = {
        tf = "terraform",
        tfvars = "terraform",
        tfstate = "json",
      },
    })
  '';
}
