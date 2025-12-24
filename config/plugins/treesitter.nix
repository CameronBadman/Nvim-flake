{ ... }:
{
  plugins.treesitter = {
    enable = true;
    settings = {
      highlight.enable = true;
      indent.enable = true;
      auto_install = false;
      sync_install = false;
    };
  };

  extraConfigLua = ''
    vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/site/parser")
  '';
}
