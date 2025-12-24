{ pkgs, ... }:
{
  plugins.lsp.servers.jdtls = {
    enable = true;
    settings = {
      java = {
        configuration.runtimes = [
          {
            name = "JavaSE-11";
            path = "${pkgs.jdk11}";
          }
          {
            name = "JavaSE-17";
            path = "${pkgs.jdk17}";
          }
          {
            name = "JavaSE-21";
            path = "${pkgs.jdk21}";
            default = true;
          }
        ];
        
        # Configure formatting settings inline
        format = {
          enabled = true;
          settings = {
            # 4 spaces, no tabs
            "org.eclipse.jdt.core.formatter.tabulation.char" = "space";
            "org.eclipse.jdt.core.formatter.tabulation.size" = "4";
            "org.eclipse.jdt.core.formatter.indentation.size" = "4";
            
            # 100 character line limit
            "org.eclipse.jdt.core.formatter.lineSplit" = "100";
            
            # Brace positioning
            "org.eclipse.jdt.core.formatter.brace_position_for_block" = "end_of_line";
            "org.eclipse.jdt.core.formatter.brace_position_for_method_declaration" = "end_of_line";
            "org.eclipse.jdt.core.formatter.brace_position_for_type_declaration" = "end_of_line";
            
            # Whitespace around operators
            "org.eclipse.jdt.core.formatter.insert_space_before_assignment_operator" = "insert";
            "org.eclipse.jdt.core.formatter.insert_space_after_assignment_operator" = "insert";
            "org.eclipse.jdt.core.formatter.insert_space_before_binary_operator" = "insert";
            "org.eclipse.jdt.core.formatter.insert_space_after_binary_operator" = "insert";
            
            # Control statements
            "org.eclipse.jdt.core.formatter.insert_space_after_comma_in_method_invocation_arguments" = "insert";
            "org.eclipse.jdt.core.formatter.insert_space_after_semicolon_in_for" = "insert";
          };
        };
      };
    };
  };

  # Don't use conform-nvim for Java - use LSP directly
  plugins.conform-nvim.settings.formatters_by_ft = {
    # Remove java from here or comment it out
    # java = [ "jdtls" ];
  };

  # Set up direct LSP formatting
  plugins.lsp.onAttach = ''
    if client.name == "jdtls" then
      -- Enable formatting capability
      client.server_capabilities.documentFormattingProvider = true
      
      -- Set up format on save for Java files
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          if vim.bo.filetype == "java" then
            vim.lsp.buf.format({ timeout_ms = 2000 })
          end
        end,
      })
    end
  '';

  # Keybindings for manual formatting
  keymaps = [
    {
      mode = "n";
      key = "<leader>f";
      action = "<cmd>lua vim.lsp.buf.format({ timeout_ms = 2000 })<CR>";
      options.desc = "Format Java file with LSP";
    }
  ];

  extraPackages = with pkgs; [
    jdk21
    maven
    gradle
    checkstyle
  ];

  plugins.treesitter.grammarPackages = [
    pkgs.vimPlugins.nvim-treesitter.builtGrammars.java
  ];

  # Set Java 21 environment
  extraConfigLua = ''
    vim.env.JAVA_HOME = "${pkgs.jdk21}"
    vim.env.PATH = "${pkgs.jdk21}/bin:" .. vim.env.PATH
  '';
}
