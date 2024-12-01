{
  pkgs ? import <nixpkgs> { },
}:

with pkgs;
[
  deadnix
  cpplint
  cmake-format # Formatter for CMake files
  dotenv-linter # Linter for `.env` files
  lua # Scripting language
  rustfmt # Rust code formatter
  astyle # Code formatter
  prettierd # Code formatter daemon
  nodePackages_latest.prettier
  asmfmt # Assembler code formatter
  clang-tools # Clang tools like `clang-tidy`
  ccls # C/C++/Obj-C language server
  typst # Fast markup-based typesetting
  typst-lsp # Language server for Typst
  shellcheck # Shell script analysis tool
  go # Go programming language
  rust-analyzer # Rust language server
  cargo # Rust package manager
  cmake # Build system generator
  yamllint # YAML linter
  hadolint # Dockerfile linter
  gcc # GNU Compiler Collection
  buf # Protobuf tool
  protolint # Protobuf linter
  checkmake # Makefile linter
  cppcheck # C++ static analysis tool
  editorconfig-checker
  gitlint
  statix
  luaformatter
  nixd
  nixfmt-rfc-style
  lua-language-server
  luajitPackages.luarocks
  nodePackages.typescript-language-server
  deno
  neovim # Text editor
  nodejs # JavaScript runtime
  python3 # Python programming language
  ruby
  tree-sitter
  mercurial
  vscode-langservers-extracted
]
