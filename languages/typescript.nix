{ pkgs, ... }:
{
  plugins.lsp.servers = {
    ts_ls = {
      enable = true;
      extraOptions = {
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all";
              includeInlayParameterNameHintsWhenArgumentMatchesName = true;
              includeInlayFunctionParameterTypeHints = true;
              includeInlayVariableTypeHints = true;
              includeInlayPropertyDeclarationTypeHints = true;
              includeInlayFunctionLikeReturnTypeHints = true;
              includeInlayEnumMemberValueHints = true;
            };
            suggest = {
              includeCompletionsForModuleExports = true;
            };
            preferences = {
              importModuleSpecifier = "relative";
              quoteStyle = "single";
            };
          };
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all";
              includeInlayParameterNameHintsWhenArgumentMatchesName = true;
              includeInlayFunctionParameterTypeHints = true;
              includeInlayVariableTypeHints = true;
              includeInlayPropertyDeclarationTypeHints = true;
              includeInlayFunctionLikeReturnTypeHints = true;
              includeInlayEnumMemberValueHints = true;
            };
          };
        };
      };
    };
    
    eslint = {
      enable = true;
      extraOptions = {
        settings = {
          workingDirectories = [ { mode = "auto"; } ];
          format = true;
          codeAction = {
            disableRuleComment = {
              enable = true;
              location = "separateLine";
            };
            showDocumentation = {
              enable = true;
            };
          };
        };
      };
    };
  };
  
  plugins.conform-nvim.settings.formatters_by_ft = {
    typescript = [ "prettier" ];
    javascript = [ "prettier" ];
    typescriptreact = [ "prettier" ];
    javascriptreact = [ "prettier" ];
    json = [ "prettier" ];
    jsonc = [ "prettier" ];
  };
  
  plugins.lint = {
    enable = true;
    lintersByFt = {
      typescript = [ "eslint" ];
      javascript = [ "eslint" ];
      typescriptreact = [ "eslint" ];
      javascriptreact = [ "eslint" ];
    };
  };
  
  extraPackages = with pkgs; [
    nodejs
    nodePackages.prettier
    nodePackages.eslint
    nodePackages.typescript-language-server
  ];
  
  plugins.treesitter.settings.ensure_installed = [ 
    "typescript" 
    "javascript" 
    "tsx" 
    "jsdoc"
    "json"
    "jsonc"
  ];
  
  extraConfigLua = ''
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
      callback = function()
        vim.lsp.buf.code_action({
          context = { only = { "source.fixAll.eslint" } },
          apply = true,
        })
      end,
    })
    
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
      callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.expandtab = true
      end,
    })
  '';
}
