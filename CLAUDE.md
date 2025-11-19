# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a modular NixVim configuration that uses Nix flakes to build a complete Neovim setup with language support, plugins, and LSP configurations.

## Building and Running

```bash
# Build the NixVim configuration
nix build

# Run the built Neovim
./result/bin/nvim

# Enter development shell with NixVim available
nix develop

# Update flake dependencies
nix flake update
```

## Architecture

The configuration is split into two main concerns:

### 1. Core Config (`/config`)
- `config/default.nix` - Main entry point that imports options, colorscheme, and plugins
- `config/options.nix` - Global Neovim options
- `config/colorscheme.nix` - Theme configuration
- `config/plugins/` - Plugin configurations organized by plugin
  - `plugins/default.nix` - Imports all plugin configurations
  - Individual plugin files (e.g., `lsp.nix`, `telescope.nix`, `treesitter.nix`)

### 2. Language Support (`/languages`)
- `languages/default.nix` - Aggregates all language modules and their `extraPackages`
- Individual language files (e.g., `rust.nix`, `go.nix`, `typescript.nix`)

Each language file follows a consistent pattern:
- Configures LSP server via `plugins.lsp.servers.<server>`
- Declares formatters via `plugins.conform-nvim.settings.formatters_by_ft.<lang>`
- Lists required external tools in `extraPackages`
- Configures treesitter parsers via `plugins.treesitter.settings.ensure_installed`
- May include language-specific autocmds via `extraConfigLua`

### Key Design Patterns

1. **extraPackages Pattern**: Each language module exports an `extraPackages` list containing all CLI tools (LSP servers, formatters, linters) needed for that language. These are aggregated in `languages/default.nix` and combined into a single `buildEnv` with `ignoreCollisions = true` to handle overlapping dependencies.

2. **Module Imports**: The flake.nix imports both `/config` and `/languages` directories when building the NixVim configuration via `makeNixvimWithModule`.

3. **Unfree Packages**: The configuration uses `pkgs-unfree` to allow installation of proprietary tools where needed.

## Adding Language Support

To add a new language:

1. Create `languages/<language>.nix` following the pattern:
```nix
{ pkgs, ... }:
{
  plugins.lsp.servers.<lsp-server> = {
    enable = true;
    settings = { ... };
  };

  plugins.conform-nvim.settings.formatters_by_ft.<lang> = [ "formatter" ];

  extraPackages = with pkgs; [
    # LSP servers, formatters, linters, etc.
  ];

  plugins.treesitter.settings.ensure_installed = [ "<parser>" ];
}
```

2. Import it in `languages/default.nix`:
   - Add `<language>Module = import ./<language>.nix { inherit pkgs; };` to the `let` block
   - Add `(<language>Module.extraPackages or [])` to `allPackages`
   - Add `./<language>.nix` to the `imports` list

## LSP Keybindings

Configured in `config/plugins/lsp.nix` via the `onAttach` hook:
- `gd` - Go to definition
- `gD` - Go to declaration
- `gr` - References
- `gi` - Implementation
- `gt` - Type definition
- `K` - Hover documentation
- `<leader>rn` - Rename
- `<leader>ca` - Code action
- `[d` / `]d` - Navigate diagnostics
- `<leader>fm` - Format buffer

Leader key is space (` `).

## Formatting

Conform.nvim handles formatting with `format_on_save` enabled globally (500ms timeout, LSP fallback). Language-specific formatters are configured in individual language files.

## Testing

Neotest plugin is configured for running tests within Neovim. Language-specific test adapters should be added to the respective language modules.
