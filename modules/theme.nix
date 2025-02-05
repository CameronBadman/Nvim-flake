{ pkgs }: {
  colorschemes.kanagawa = {
    enable = true;
    theme = "wave";
    transparent = true;
  };
  
  # Transparency settings
  extraConfigLua = ''
    -- Enable transparency
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
  '';
}
