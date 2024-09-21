{ pkgs ? import <nixpkgs> {} }:

with pkgs;
[
  neovim
  nodejs
  python3
  go
  rust-analyzer
  cmake
  yamllint
  hadolint
  gcc
  buf
  protolint
  checkmake
  cppcheck
  cmake-format
  dotenv-linter
  lua
  rustfmt
  astyle
  prettierd
  asmfmt
  clang-tools
  ccls
  typst
  typst-lsp
  docker
  shellcheck
  nerdfonts
  fd
  ripgrep
  tmux
]

