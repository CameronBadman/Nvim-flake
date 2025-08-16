{
  plugins.lsp.servers.lua_ls = {
    enable = true;
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT";
        };
        diagnostics = {
          globals = [ "vim" ];
        };
        workspace = {
          library = {
            "\${3rd}/luv/library" = true;
            "\${3rd}/busted/library" = true;
          };
          checkThirdParty = false;
        };
        telemetry = {
          enable = false;
        };
      };
    };
  };
}
