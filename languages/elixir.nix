{ pkgs, ... }:
{
  plugins.lsp.servers.elixirls = {
    enable = true;
    extraOptions = {
      settings = {
        elixirLS = {
          dialyzerEnabled = true;
          fetchDeps = false;
          enableTestLenses = true;
          suggestSpecs = true;
          signatureAfterComplete = true;
          autoInsertRequiredAlias = true;
          mixEnv = "dev";
        };
      };
    };
  };
  
  plugins.conform-nvim.settings.formatters_by_ft = {
    elixir = [ "mix" ];
    heex = [ "mix" ];
    eex = [ "mix" ];
  };
  
  extraPackages = with pkgs; [
    elixir
    elixir-ls
  ];
  
  plugins.treesitter.settings.ensure_installed = [ 
    "elixir" 
    "heex" 
    "eex" 
  ];
  
  extraConfigLua = ''
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = { "*.ex", "*.exs", "*.heex", "*.eex" },
      callback = function()
        vim.lsp.buf.format({ async = false })
      end,
    })
    
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "elixir", "heex", "eex" },
      callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.expandtab = true
      end,
    })
    
    vim.filetype.add({
      extension = {
        heex = "heex",
        eex = "eex",
      },
    })
  '';
}
