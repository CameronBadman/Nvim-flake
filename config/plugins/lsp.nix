{ lib, ... }:
{
  plugins.lsp = {
    enable = true;
    
    servers = lib.mkDefault {
      # Base servers - external flakes can extend this
      nil_ls.enable = true;  # Nix LSP (renamed from nil-ls)
    };
    
    keymaps = lib.mkDefault {
      silent = true;
      lspBuf = {
        gd = "definition";
        gr = "references";
        gt = "type_definition";
        gi = "implementation";
        K = "hover";
        "<F2>" = "rename";
      };
      diagnostic = {
        "<leader>cd" = "open_float";
        "[d" = "goto_prev";
        "]d" = "goto_next";
      };
    };
  };

  # Base keymaps that external flakes might want to extend
  keymaps = lib.mkDefault [
    {
      mode = "n";
      key = "<leader>ca";
      action = ":lua vim.lsp.buf.code_action()<CR>";
      options = {
        desc = "Code actions";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>cf";
      action = ":lua vim.lsp.buf.format()<CR>";
      options = {
        desc = "Format code";
        silent = true;
      };
    }
  ];
}
