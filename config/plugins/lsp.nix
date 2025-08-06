{
  plugins = {
    # LSP Configuration
    lsp = {
      enable = true;
      
      # Language servers
      servers = {
        # C/C++
        clangd = {
          enable = true;
          cmd = [ "clangd" "--background-index" "--clang-tidy" "--header-insertion=iwyu" ];
        };

        # Rust
        rust_analyzer = {
          enable = true;
          installRustc = true;
          installCargo = true;
          settings = {
            "rust_analyzer" = {
              cargo = {
                allFeatures = true;
              };
              checkOnSave = {
                command = "clippy";
              };
              procMacro = {
                enable = true;
              };
            };
          };
        };

        # Python
        pyright = {
          enable = true;
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic";
                autoSearchPaths = true;
                useLibraryCodeForTypes = true;
              };
            };
          };
        };

        # Go
        gopls = {
          enable = true;
          settings = {
            gopls = {
              analyses = {
                unusedparams = true;
                shadow = true;
              };
              staticcheck = true;
              gofumpt = true;
            };
          };
        };

        # Gleam
        gleam = {
          enable = true;
        };

        # OCaml
        ocamllsp = {
          enable = true;
        };

        # YAML (for Kubernetes and Docker Compose)
        yamlls = {
          enable = true;
          settings = {
            yaml = {
              schemas = {
                "https://json.schemastore.org/github-workflow.json" = "/.github/workflows/*";
                "https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json" = "/*.k8s.yaml";
                "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json" = "/docker-compose*.yml";
              };
            };
          };
        };

        # Docker
        dockerls = {
          enable = true;
        };

        # C#
        omnisharp = {
          enable = true;
          settings = {
            FormattingOptions = {
              EnableEditorConfigSupport = true;
            };
            RoslynExtensionsOptions = {
              EnableAnalyzersSupport = true;
            };
          };
        };

        # Java
        jdtls = {
          enable = true;
        };

        # JSON (useful for configuration files)
        jsonls = {
          enable = true;
        };

        # Nix (since you're using nixvim)
        nil_ls = {
          enable = true;
          settings = {
            "nil" = {
              formatting = {
                command = [ "nixfmt" ];
              };
            };
          };
        };
      };

      # Global LSP settings
      keymaps = {
        silent = true;
        lspBuf = {
          gd = "definition";
          gD = "declaration"; 
          gi = "implementation";
          gt = "type_definition";
          gr = "references";
          K = "hover";
          "<leader>k" = "signature_help";
          "<leader>rn" = "rename";
          "<leader>ca" = "code_action";
          "<leader>f" = "format";
        };
        diagnostic = {
          "<leader>e" = "open_float";
          "[d" = "goto_prev";
          "]d" = "goto_next";
          "<leader>q" = "setloclist";
        };
      };

      # LSP UI enhancements
      onAttach = ''
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        
        -- Highlight symbol under cursor
        if client.server_capabilities.documentHighlightProvider then
          vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
          vim.api.nvim_create_autocmd("CursorHold", {
            group = "lsp_document_highlight",
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd("CursorMoved", {
            group = "lsp_document_highlight", 
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
          })
        end
      '';
    };

    # LSP formatting
    lsp-format = {
      enable = true;
    };

    # LSP progress indicator (uncomment if available)
    # fidget = { enable = true; };

    # Better LSP UI (uncomment if available)
    # lspsaga = { enable = true; };

    # Treesitter for better syntax highlighting
    treesitter = {
      enable = true;
      nixvimInjections = true;
      settings = {
        highlight = {
          enable = true;
          additional_vim_regex_highlighting = false;
        };
        indent = {
          enable = true;
        };
        ensure_installed = [
          "c"
          "cpp"
          "rust"
          "python"
          "go"
          "gleam"
          "ocaml"
          "sql"
          "yaml"
          "json"
          "dockerfile"
          "bash"
          "nix"
          "lua"
          "vim"
          "markdown"
        ];
      };
    };
  };

  # Additional configuration
  extraConfigLua = ''
    -- LSP Diagnostics configuration
    vim.diagnostic.config({
      virtual_text = {
        prefix = '●',
        source = "if_many",
      },
      float = {
        source = "always",
        border = "rounded",
      },
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    })

    -- LSP diagnostic signs
    local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end
  '';
}
