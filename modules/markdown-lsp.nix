# modules/markdown-lsp.nix
{ pkgs, lib, ... }:

let
  # Create EFM config file
  efmConfig = pkgs.writeTextFile {
    name = "efm-config.yaml";
    text = ''
      version: 2
      root-markers:
        - .git/

      tools:
        prettier: &prettier
          format-command: 'prettier --stdin-filepath ${"\${INPUT}"}'
          format-stdin: true

        markdownlint: &markdownlint
          lint-command: 'markdownlint -s'
          lint-stdin: true
          lint-formats:
            - '%f:%l:%c %m'
            - '%f:%l %m'
            - '%f: %l: %m'

      languages:
        markdown:
          - <<: *markdownlint
          - <<: *prettier
    '';
  };

  # Create a wrapper for efm-langserver that uses our config
  efmLangServerWrapped = pkgs.writeShellScriptBin "efm-langserver-markdown" ''
    ${pkgs.efm-langserver}/bin/efm-langserver -c ${efmConfig}
  '';
in
{
  # This function provides the wrapped efm-langserver
  pkgs = {
    inherit efmLangServerWrapped efmConfig;
  };
  
  # Dependencies required for Markdown LSP support
  dependencies = with pkgs; [
    # LSP servers
    marksman
    efm-langserver
    ltex-ls
    
    # Markdown tools
    nodePackages.markdownlint-cli
    nodePackages.prettier
    
    # Spelling and grammar
    hunspell
    hunspellDicts.en_US
  ];
}
