{ pkgs, ... }:
{
  plugins.lsp.servers.gopls = {
    enable = true;
    settings.gopls = {
      analyses = {
        unusedparams = true;
        unusedwrite = true;
        shadow = true;
        nilness = true;
        unusedvariable = true;
        useany = true;
        composites = true;
        ST1003 = true;
        undeclaredname = true;
        fillreturns = true;
        nonewvars = true;
        fillstruct = true;
      };
      staticcheck = true;
      gofumpt = true;
      vulncheck = "Imports";
      semanticTokens = true;
      usePlaceholders = true;
      completeUnimported = true;
      deepCompletion = true;
      matcher = "Fuzzy";
      experimentalPostfixCompletions = true;
      hints = {
        assignVariableTypes = true;
        compositeLiteralFields = true;
        compositeLiteralTypes = true;
        constantValues = true;
        functionTypeParameters = true;
        parameterNames = true;
        rangeVariableTypes = true;
      };
      codelenses = {
        gc_details = true;
        generate = true;
        regenerate_cgo = true;
        test = true;
        tidy = true;
        upgrade_dependency = true;
        vendor = true;
      };
      diagnosticsDelay = "300ms";
      symbolMatcher = "FastFuzzy";
      symbolStyle = "Dynamic";
    };
  };
  
  plugins.conform-nvim.settings.formatters_by_ft.go = [ "goimports" "gofumpt" ];
  
  extraPackages = with pkgs; [
    go
    gotools  # includes goimports
    gopls
    golangci-lint
    delve
    gcc
    gomodifytags
    impl
    gotests
    iferr
    gofumpt
  ];
  
  plugins.treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
    go
    gomod
    gosum
  ];
  
  plugins.dap-go.enable = true;
  
  extraConfigLua = ''
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "go",
      callback = function()
        vim.bo.expandtab = false
        vim.bo.tabstop = 4
        vim.bo.shiftwidth = 4
      end,
    })
  '';
}
