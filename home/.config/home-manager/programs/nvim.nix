{ pkgs }:
with pkgs;
[
  # marksman
  # astyle
  # cpplint
  # cmake-format
  deadnix
  dotenv-linter
  lua
  # rustfmt
  prettierd
  nodePackages_latest.prettier
  # asmfmt
  # clang-tools
  # ccls
  typst
  tinymist
  shellcheck
  # go
  # rust-analyzer
  # cargo
  # cmake
  yamllint
  hadolint
  # gcc
  # buf
  # protolint
  # checkmake
  # cppcheck
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
  markdownlint-cli
  bash-language-server
  dockerfile-language-server-nodejs
  glow
  yaml-language-server
  protols
  buf
  docker-compose-language-service
  emmet-ls
  helm-ls
]
