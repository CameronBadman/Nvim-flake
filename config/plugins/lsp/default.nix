# lsp/default.nix - Global LSP configuration
{
  plugins = {
    # Core LSP Configuration
    lsp = {
      enable = true;

      # Global LSP keymaps
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
          "<leader>d" = "open_float";
          "[d" = "goto_prev";
          "]d" = "goto_next";
          "<leader>q" = "setloclist";
        };
      };

      # Global LSP onAttach configuration
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
          # Systems Programming
          "c"
          "cpp"
          "rust"
          "go"

          # Web Development
          "javascript"
          "typescript"
          "tsx"
          "html"
          "css"

          # General Purpose
          "python"
          "java"
          "lua"

          # Functional Programming
          "haskell"
          "elixir"
          "erlang"
          "eex"
          "heex"
          "gleam"
          "ocaml"

          # Enterprise
          "c_sharp"

          # Configuration & DevOps
          "nix"
          "yaml"
          "json"
          "terraform"
          "hcl"
          "dockerfile"
          "toml"

          # Scripting & Utilities
          "bash"
          "fish"
          "vim"
          "vimdoc"
          "regex"

          # Documentation & Markup
          "markdown"
          "markdown_inline"
          "xml"

          # Additional useful parsers
          "gitignore"
          "gitcommit"
          "diff"
          "sql"
          "comment"
        ];
      };
    };
  };

  # Global LSP configuration
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
