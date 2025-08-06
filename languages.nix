{ pkgs, ... }:

{
  # Include language toolchains (compilers/runtimes) that LSPs need to function
  extraPackages = with pkgs; [
    # C/C++ Compilers & Build Tools (for clangd LSP)
    gcc clang cmake gnumake pkg-config gdb lldb
    # Rust Toolchain (for rust_analyzer LSP)
    rustc cargo rustfmt clippy
    # Python Runtime (for pyright LSP)
    python311 python311Packages.pip python311Packages.setuptools python311Packages.wheel poetry black isort mypy ruff
    # Go Compiler (for gopls LSP)
    go gofumpt golangci-lint delve
    # Java Runtime (for jdtls LSP)
    jdk21 maven gradle
    # C# Runtime (for omnisharp LSP)
    dotnet-sdk_8 mono
    # Gleam Runtime (for gleam LSP)
    gleam erlang
    # OCaml Runtime (for ocamllsp LSP)
    ocaml dune_3 opam ocamlformat
    
    # JavaScript/TypeScript Runtime (for tsserver LSP)
    nodejs nodePackages_latest.typescript-language-server typescript
    
    # Lua Runtime (for lua-ls LSP)
    sumneko-lua-language-server stylua
    
    # Haskell Runtime (for haskell-language-server LSP)
    haskell-language-server hlint ormolu ghc cabal-install stack pandoc
    
    # Terraform (for terraformls LSP)
    terraform terraform-ls terraform-docs tflint tfsec
    
    # Elixir/Erlang Runtime (for elixirls LSP)
    elixir elixir_ls rebar3 hex
    
    # SQL Databases (for sqlls LSP)
    sqlite postgresql_15 mysql80 sqlfluff
    # Docker & Container Tools (for dockerls/yamlls LSP)
    docker docker-compose
    # Kubernetes Tools (for yamlls LSP with k8s schemas)
    kubectl
    # General Development Tools
    git curl jq yq-go
    # Formatters & Linters that LSPs might use
    prettier shfmt shellcheck yamllint
  ];

  # Set environment variables for better language support
  extraConfigLua = ''
    -- Python path configuration
    vim.g.python3_host_prog = "${pkgs.python311}/bin/python3"
    
    -- Rust environment
    vim.env.RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}"
    
    -- Elixir environment
    vim.env.MIX_ENV = "dev"
    vim.env.ERL_AFLAGS = "-kernel shell_history enabled"
  '';

  # File type associations for LSP
  extraConfigVim = ''
    autocmd BufNewFile,BufRead *.gleam setfiletype gleam
    autocmd BufNewFile,BufRead Dockerfile* setfiletype dockerfile
    autocmd BufNewFile,BufRead docker-compose*.yml setfiletype yaml
    autocmd BufNewFile,BufRead *.k8s.yaml setfiletype yaml
    autocmd BufNewFile,BufRead *.tf setfiletype terraform
    autocmd BufNewFile,BufRead *.tfvars setfiletype terraform
    autocmd BufNewFile,BufRead *.hcl setfiletype hcl
    autocmd BufNewFile,BufRead *.ex setfiletype elixir
    autocmd BufNewFile,BufRead *.exs setfiletype elixir
    autocmd BufNewFile,BufRead *.eex setfiletype eelixir
    autocmd BufNewFile,BufRead *.heex setfiletype eelixir
    autocmd BufNewFile,BufRead *.leex setfiletype eelixir
    autocmd BufNewFile,BufRead *.ts setfiletype typescript
    autocmd BufNewFile,BufRead *.tsx setfiletype typescriptreact
    autocmd BufNewFile,BufRead *.hs setfiletype haskell
    autocmd BufNewFile,BufRead *.lhs setfiletype haskell
  '';
}
