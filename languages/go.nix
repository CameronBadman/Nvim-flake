{ pkgs, ... }:
{
  plugins.lsp.servers.golangci_lint_ls = {
    enable = true;
    filetypes = [ "go" "gomod" ];
  };

  plugins.lsp.servers.gopls = {
    enable = true;
    settings.gopls = {
      analyses = {
        # Strictness - all enabled
        appends = true;
        asmdecl = true;
        assign = true;
        atomic = true;
        atomicalign = true;
        bools = true;
        buildtag = true;
        cgocall = true;
        composites = true;
        copylocks = true;
        deepequalerrors = true;
        defers = true;
        directive = true;
        errorsas = true;
        fieldalignment = true;
        fillreturns = true;
        fillstruct = true;
        httpresponse = true;
        ifaceassert = true;
        infertypeargs = true;
        loopclosure = true;
        lostcancel = true;
        nilfunc = true;
        nilness = true;
        nonewvars = true;
        noresultvalues = true;
        printf = true;
        shadow = true;
        shift = true;
        simplifycompositelit = true;
        simplifyrange = true;
        simplifyslice = true;
        slog = true;
        sortslice = true;
        stdmethods = true;
        stringintconv = true;
        structtag = true;
        testinggoroutine = true;
        tests = true;
        timeformat = true;
        undeclaredname = true;
        unmarshal = true;
        unreachable = true;
        unsafeptr = true;
        unusedparams = true;
        unusedresult = true;
        unusedvariable = true;
        unusedwrite = true;
        useany = true;

        # Staticcheck analyses (ST prefixed)
        ST1000 = true;
        ST1001 = true;
        ST1003 = true;
        ST1005 = true;
        ST1006 = true;
        ST1008 = true;
        ST1011 = true;
        ST1012 = true;
        ST1013 = true;
        ST1015 = true;
        ST1016 = true;
        ST1017 = true;
        ST1018 = true;
        ST1019 = true;
        ST1020 = true;
        ST1021 = true;
        ST1022 = true;
        ST1023 = true;
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
      directoryFilters = [
        "-node_modules"
        "-vendor"
      ];
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
      diagnosticsDelay = "100ms";
      symbolMatcher = "FastFuzzy";
      symbolStyle = "Dynamic";
      allExperiments = true;

      # Make diagnostics strict and visible
      noIncrementalSync = false;
      completionBudget = "100ms";
      diagnosticsTrigger = "Edit";
    };
  };
  
  plugins.conform-nvim.settings.formatters_by_ft.go = [ "goimports" "gofumpt" ];
  
  extraPackages = with pkgs; [
    go
    gotools  # includes goimports
    gopls
    golangci-lint
    golangci-lint-langserver
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

        -- Make diagnostics more visible in Go files
        local opts = { buffer = true, silent = true }
        vim.keymap.set('n', '<leader>da', vim.diagnostic.setqflist, vim.tbl_extend('force', opts, { desc = 'All diagnostics to quickfix' }))
        vim.keymap.set('n', '<leader>db', function()
          vim.diagnostic.setloclist({ bufnr = 0 })
        end, vim.tbl_extend('force', opts, { desc = 'Buffer diagnostics to loclist' }))
      end,
    })

    -- Ensure golangci-lint-langserver is initialized for Go projects
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "*.go",
      callback = function()
        -- Force diagnostic refresh on buffer enter
        vim.defer_fn(function()
          vim.diagnostic.show()
        end, 500)
      end,
    })
  '';
}
