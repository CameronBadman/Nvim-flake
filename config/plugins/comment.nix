{
  plugins.comment = {
    enable = true;
    settings = {
      # Line-wise toggle
      toggler = {
        line = "gcc"; # Toggle line comment
        block = "gbc"; # Toggle block comment
      };

      # Operator-pending mappings (for visual mode)
      opleader = {
        line = "gc"; # Toggle line comment in visual
        block = "gb"; # Toggle block comment in visual
      };

      # Language-aware commenting
      sticky = true; # Maintain cursor position
      ignore = "^$"; # Ignore empty lines
    };
  };
}
