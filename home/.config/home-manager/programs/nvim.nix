{ pkgs, pkgs-unstable }:
with pkgs;
[
  # marksman
  # astyle
  # cpplint
  # cmake-format
  # zig
  deadnix
  dotenv-linter
  lua
  prettierd
  nodePackages_latest.prettier
  # asmfmt
  # clang-tools
  # ccls
  # typst
  # tinymist
  shellcheck
  # go
  # cmake
  yamllint
  # hadolint
  gcc
  gnumake
  # buf
  # protolint
  # checkmake
  # cppcheck
  pkg-config
  editorconfig-checker
  gitlint
  statix
  luaformatter
  nixd
  nixfmt-rfc-style
  lua-language-server
  luajitPackages.luarocks
  nodePackages.typescript-language-server
  # deno
  nodejs
  python3
  # ruby
  tree-sitter
  # mercurial
  vscode-langservers-extracted
  vimPlugins.wilder-nvim
  # markdownlint-cli
  # bash-language-server
  # dockerfile-language-server-nodejs
  # glow
  yaml-language-server
  # protols
  # buf
  # docker-compose-language-service
  emmet-ls
  # helm-ls
  # vue-language-server
]
++ [
  pkgs-unstable.rustfmt
  pkgs-unstable.rust-analyzer
  pkgs-unstable.rustc
  pkgs-unstable.clippy
  pkgs-unstable.cargo
]
