{ pkgs, ... }:

{
  # Include language toolchains (compilers/runtimes) that LSPs need to function
  extraPackages = with pkgs; [
    # C/C++ Compilers & Build Tools (for clangd LSP)
    gcc
    clang
    cmake
    gnumake
    pkg-config
    gdb
    lldb
    valgrind

    # Rust Toolchain (for rust-analyzer LSP)
    rustc
    cargo
    rustfmt
    clippy

    # Python Runtime (for pyright LSP)
    python311
    python311Packages.pip
    python311Packages.setuptools
    python311Packages.wheel
    poetry
    black
    isort
    mypy
    ruff

    # Go Compiler (for gopls LSP)
    go
    gofumpt
    golangci-lint
    delve # Go debugger

    # Java Runtime (for jdtls LSP)
    jdk21
    maven
    gradle

    # C# Runtime (for omnisharp LSP)
    dotnet-sdk_8
    mono

    # Gleam Runtime (for gleam LSP)
    gleam
    erlang

    # OCaml Runtime (for ocamllsp LSP)
    ocaml
    dune_3
    opam
    ocamlformat

    # SQL Databases (for sqlls LSP)
    sqlite
    postgresql_15
    mysql80
    sqlfluff # SQL linter/formatter

    # Docker & Container Tools (for dockerls/yamlls LSP)
    docker
    docker-compose

    # Kubernetes Tools (for yamlls LSP with k8s schemas)
    kubectl

    # General Development Tools
    git
    curl
    jq
    yq-go # YAML processor
    
    # Formatters & Linters that LSPs might use
    prettier # JS/TS/JSON/YAML/Markdown
    shfmt # Shell script formatter
    shellcheck # Shell script linter
    yamllint
  ];

  # Set environment variables for better language support
  extraConfigLua = ''
    -- Python path configuration
    vim.g.python3_host_prog = "${pkgs.python311}/bin/python3"
    
    -- Node.js path (if you add it later)
    -- vim.g.node_host_prog = "${pkgs.nodejs}/bin/node"
    
    -- Rust environment
    vim.env.RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}"
  '';

  # File type associations for LSP
  extraConfigVim = ''
    autocmd BufNewFile,BufRead *.gleam setfiletype gleam
    autocmd BufNewFile,BufRead Dockerfile* setfiletype dockerfile
    autocmd BufNewFile,BufRead docker-compose*.yml setfiletype yaml
    autocmd BufNewFile,BufRead *.k8s.yaml setfiletype yaml
  '';
}
