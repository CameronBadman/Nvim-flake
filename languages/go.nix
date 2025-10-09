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
    gotools
    gopls
    golangci-lint
    delve
    gomodifytags
    impl
    gotests
    iferr
    gofumpt
  ];
  
  plugins.treesitter.settings.ensure_installed = [ "go" "gomod" "gowork" "gosum" ];
  
  plugins.dap-go.enable = true;
  
  extraConfigLua = ''
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.go",
      callback = function()
        local params = vim.lsp.util.make_range_params()
        params.context = {only = {"source.organizeImports"}}
        local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
        for _, res in pairs(result or {}) do
          for _, r in pairs(res.result or {}) do
            if r.edit then
              vim.lsp.util.apply_workspace_edit(r.edit, "utf-8")
            else
              vim.lsp.buf.execute_command(r.command)
            end
          end
        end
      end,
    })
    
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
