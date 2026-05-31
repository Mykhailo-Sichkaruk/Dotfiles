{ pkgs, ... }:
{
  plugins.treesitter = {
    enable = true;
    grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      bash
      css
      diff
      html
      javascript
      jsdoc
      json
      lua
      markdown
      markdown_inline
      nix
      python
      query
      regex
      toml
      tsx
      typescript
      vim
      vimdoc
      yaml
    ];
    settings = {
      highlight.enable = true;
      indent.enable = true;
      incremental_selection = {
        enable = true;
        keymaps = {
          init_selection = "gnn";
          node_decremental = "grm";
          node_incremental = "grn";
          scope_incremental = "grc";
        };
      };
    };
  };
}
