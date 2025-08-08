{
  plugins.indent-blankline = {
    enable = true;
    settings = {
      indent = {
        char = "▏";
        tab_char = "▏";
      };
      scope = {
        enabled = true;
        char = "▎";
        show_start = true;
        show_end = true;
        show_exact_scope = true;
        injected_languages = false;
        highlight = [
          "Function"
          "Label"
          "Conditional"
          "Repeat"
          "Keyword"
        ];
        include = {
          node_type = {
            "*" = [
              "class"
              "return_statement"
              "function"
              "method"
              "^if"
              "^while"
              "^for"
              "^object"
              "^table"
              "arguments"
              "parameter_list"
              "element"
              "block"
              "dictionary"
              "array"
            ];
          };
        };
        priority = 1000;
      };
      exclude = {
        filetypes = [
          "help"
          "alpha"
          "dashboard"
          "neo-tree"
          "Trouble"
          "trouble"
          "lazy"
          "mason"
          "notify"
          "toggleterm"
          "lazyterm"
          "TelescopePrompt"
          "lspinfo"
          "packer"
          "checkhealth"
          "man"
          "gitcommit"
          "TelescopeResults"
          "oil"
        ];
        buftypes = [
          "terminal"
          "nofile"
          "quickfix"
          "prompt"
        ];
      };
    };
  };
}
