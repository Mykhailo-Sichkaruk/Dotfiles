#!/bin/bash

# custom
[[ -z ${XDG_CONFIG_HOME} ]] && export XDG_CONFIG_HOME="$HOME/.config"
[[ -z ${XDG_CACHE_HOME} ]] && export XDG_CACHE_HOME="$HOME/.cache"
[[ -z ${XDG_DATA_HOME} ]] && export XDG_DATA_HOME="$HOME/.local/share"

export PATH=/home/misha/.nvm/versions/node/v20.9.0/bin:/home/misha/.npm-global/bin:/usr/local/go/bin:/home/misha/.cargo/bin:/home/misha/.local/bin:/home/misha/bin:/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin
export EDITOR=/usr/bin/nvim
export BROWSER=/usr/bin/qutebrowser
export TERM=/usr/bin/alacritty
# export WALLPAPERS_DIR=/home/ddystopia/Media/wallpapers
# export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
# export LESSHISTFILE=-

# export LIBGL_ALWAYS_SOFTWARE=1

# system
# export QT_QPA_PLATFORMTHEME="qt5ct"
# export QT_AUTO_SCREEN_SCALE_FACTOR=0
# export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
# export GTK_THEME="Kripton"

export TERMINAL=alacritty

# export NVM_DIR="$HOME/.config/nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

export NPM_GLOBAL="$HOME/.npm-global"
export PATH="$NPM_GLOBAL/bin:$PATH"

# Change keyboard layout 
# setxkbmap -layout "us,ru" -option "grp:alt_shift_toggle"

xset r rate 250 50
xset b off
