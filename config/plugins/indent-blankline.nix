{
  plugins.indent-blankline = {
    enable = true;
    settings = {
      indent = {
        char = "│";
        tab_char = "│";
      };
      scope = {
        enabled = true;
        char = "│";
        show_start = true;
        show_end = false;
        injected_languages = false;
        highlight = [
          "Function"
          "Label"
        ];
        priority = 500;
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
