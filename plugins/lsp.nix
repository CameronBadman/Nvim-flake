# plugins/lsp.nix
{ pkgs }: {
  enable = true;

  # Keymaps for LSP functionality
  keymaps = {
    diagnostic = {
      # Navigate diagnostics
      "<leader>j" = "goto_next";
      "<leader>k" = "goto_prev";
    };

    lspBuf = {
      # GoTo code navigation
      "gd" = {
        action = "definition";
        desc = "Go to definition";
      };
      
      "gr" = {
        action = "references";
        desc = "Show references";
      };
      
      "gi" = {
        action = "implementation";
        desc = "Go to implementation";
      };
      
      "gy" = {
        action = "type_definition";
        desc = "Go to type definition";
      };
      
      # Symbol information
      "K" = {
        action = "hover";
        desc = "Show hover documentation";
      };
      
      "<C-k>" = {
        action = "signature_help";
        desc = "Show signature help";
      };
      
      # Code actions
      "<leader>rn" = {
        action = "rename";
        desc = "Rename symbol";
      };
      
      "<leader>ca" = {
        action = "code_action";
        desc = "Code actions";
      };
    };
  };

  # Server configurations
  servers = {
    # Nix language server
    nixd = {
      enable = true;
    };

    # Lua language server
    lua_ls = {
      enable = true;
      
      settings = {
        # Allow vim global
        diagnostics.globals = [ "vim" ];
        
        # Disable third party checks
        workspace.checkThirdParty = false;
        
        # Disable telemetry
        telemetry.enable = false;
      };
    };

    # Python language server
    pyright = {
      enable = true;
      
      settings = {
        python.analysis = {
          # Analysis settings
          typeCheckingMode = "basic";
          diagnosticMode = "workspace";
          
          # Inlay hints
          inlayHints = {
            functionReturnTypes = true;
            variableTypes = true;
          };
        };
      };
    };

    # TypeScript/JavaScript server
    tsserver = {
      enable = true;
      
      settings = {
        # Enable auto imports
        preferences = {
          importModuleSpecifier = "relative";
          includeCompletionsForModuleExports = true;
        };
      };
    };

    # Go language server
    gopls = {
      enable = true;
      
      settings = {
        # Use placeholders for completion
        usePlaceholders = true;
        
        # Enable all useful analyses
        analyses = {
          # Core analyses
          unusedparams = true;
          shadow = true;
          assign = true;
          nilness = true;
          structtag = true;
          deepequalerrors = true;
          
          # Additional analyses
          fieldalignment = true;
          unusedwrite = true;
          unusedvariable = true;
          useany = true;
        };
        
        # Additional settings
        staticcheck = true;
        completeUnimported = true;
        semanticTokens = true;
        directoryFilters = [ "-.git" "-node_modules" ];
      };
    };
  };
}
