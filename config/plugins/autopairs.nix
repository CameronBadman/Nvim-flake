{
  plugins.nvim-autopairs = {
    enable = true;
    settings = {
      check_ts = true;
      disable_filetype = [ "TelescopePrompt" ];
    };
  };

  # Visual mode wrapping keymaps
  keymaps = [
    {
      mode = "v";
      key = "<leader>(";
      action = "<Esc>`>a)<Esc>`<i(<Esc>";
    }
    {
      mode = "v";
      key = "<leader>[";
      action = "<Esc>`>a]<Esc>`<i[<Esc>";
    }
    {
      mode = "v";
      key = "<leader>{";
      action = "<Esc>`>a}<Esc>`<i{<Esc>";
    }
    {
      mode = "v";
      key = "<leader>\"";
      action = "<Esc>`>a\"<Esc>`<i\"<Esc>";
    }
    {
      mode = "v";
      key = "<leader>'";
      action = "<Esc>`>a'<Esc>`<i'<Esc>";
    }
    {
      mode = "v";
      key = "<leader>`";
      action = "<Esc>`>a`<Esc>`<i`<Esc>";
    }
  ];
}
