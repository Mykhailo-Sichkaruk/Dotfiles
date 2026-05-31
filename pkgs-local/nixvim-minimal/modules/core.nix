{ pkgs, ... }:
{
  env.NVIM_APPNAME = "nixvim-minimal";

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

  extraPackages = with pkgs; [
    fd
    gh
    git
    luaformatter
    nixfmt-rfc-style
    nodejs
    prettier
    prettierd
    ripgrep
    ruff
  ];
}
