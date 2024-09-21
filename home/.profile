#!/bin/bash

# custom
[[ -z ${XDG_CONFIG_HOME} ]] && export XDG_CONFIG_HOME="$HOME/.config"
[[ -z ${XDG_CONFIG_HOME} ]] && export XDG_DOWNLOAD_DIR="$HOME/Downloads"
[[ -z ${XDG_CACHE_HOME} ]] && export XDG_CACHE_HOME="$HOME/.cache"
[[ -z ${XDG_DATA_HOME} ]] && export XDG_DATA_HOME="$HOME/.local/share"

export PATH=home/ms/.cargo/bin:/home/ms/.local/bin:/home/ms/bin:/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin
export EDITOR=/usr/bin/nvim
export BROWSER=/usr/bin/vieb
export TERM=/usr/bin/alacritty
export TERMINAL=alacritty
export SHELL=/usr/bin/fish
# export WALLPAPERS_DIR=/home/ddystopia/Media/wallpapers
# export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
# export LESSHISTFILE=-

# export LIBGL_ALWAYS_SOFTWARE=1

# system
export QT_QPA_PLATFORMTHEME="qt5ct"
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
export GTK_THEME="BlackAndWhite"

export NPM_GLOBAL="$HOME/.npm-global"
export PATH="$NPM_GLOBAL/bin:$PATH"

export LC_ALL=en_US.UTF-8

xset r rate 250 50
xset b off
numlockx on
