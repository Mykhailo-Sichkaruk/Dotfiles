{ pkgs, pkgs-unstable, ... }:
{
  env.NVIM_APPNAME = "vix";

  viAlias = true;
  vimAlias = true;

  globals = {
    mapleader = " ";
    maplocalleader = " ";
  };

  opts = {
    breakindent = true;
    clipboard = "unnamedplus";
    confirm = true;
    exrc = true;
    expandtab = true;
    hlsearch = true;
    inccommand = "split";
    ignorecase = true;
    mouse = "a";
    number = true;
    relativenumber = true;
    scrolloff = 8;
    shiftwidth = 2;
    showmode = false;
    signcolumn = "yes";
    smartcase = true;
    splitbelow = true;
    splitright = true;
    tabstop = 2;
    termguicolors = true;
    timeoutlen = 300;
    undofile = true;
    updatetime = 250;
    wrap = false;
  };

  extraPackages =
    with pkgs;
    [
      fd
      gh
      git
      nixfmt
      nodejs
      prettier
      prettierd
      ripgrep
      ruff
      stylua
    ]
    ++ [
      pkgs-unstable.typescript
    ];
}
