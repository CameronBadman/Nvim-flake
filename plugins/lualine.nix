{ pkgs }: {
  plugins = {
    lualine = {
      enable = true;
      theme = "kanagawa";
      componentSeparators = {
        left = "";
        right = "";
      };
      sectionSeparators = {
        left = "";
        right = "";
      };
    };
  };
}
