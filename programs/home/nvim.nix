{ pkgs, pkgs-unstable }:
with pkgs;
[
  deadnix
  dotenv-linter
  lua
  prettierd
  nodePackages_latest.prettier
  yamllint
  gcc
  statix
  luaformatter
  nixd
  nixfmt-rfc-style
  lua-language-server
  nodePackages.typescript-language-server
  typescript-go
  nodejs_24
  python3
  tree-sitter
  vscode-langservers-extracted
  direnv
  nix-direnv
  python313Packages.python-lsp-ruff
  ruff
  python313Packages.python-lsp-server
  python313Packages.python-lsp-ruff
  libgcc
]
++ [
  # pkgs-unstable.rustfmt
  # pkgs-unstable.rust-analyzer
  # pkgs-unstable.rustc
  # pkgs-unstable.clippy
  # pkgs-unstable.cargo
  # pkgs-unstable.mcp-language-server
]
