{ pkgs }: {
  enable = true;
  servers = {
    gopls.enable = true;
    rust-analyzer.enable = true;
    tsserver.enable = true;
    lua-ls.enable = true;
    nil.enable = true;
    pylsp.enable = true;
    clangd.enable = true;
  };
  keymaps = {
    diagnostic = {
      "<leader>j" = "goto_next";
      "<leader>k" = "goto_prev";
    };
    lspBuf = {
      "gd" = "definition";
      "gr" = "references";
      "K" = "hover";
      "<leader>r" = "rename";
      "<leader>a" = "code_action";
    };
  };
}
