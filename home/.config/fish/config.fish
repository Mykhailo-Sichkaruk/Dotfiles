if status is-interactive
    # Commands to run in interactive sessions can go here
  set fish_cursor_insert line
  set fish_greeting
  fish_config theme choose "Dracula Official"
  function fish_mode_prompt; end

  alias nowtime='date +"%T"' #this will show the current time in 24hrs format as HH:MM:SS
  alias nowdate='date +"%d-%m-%Y"' #this will show the current date in format dd-MM-YY
  alias cls="clear"
  alias e="eza -ab --group-directories-first --icons"
  alias ex="eza -ab --group-directories-first --icons -lTL 1 --no-time --git --no-user"
  alias ls="ls --color -L"
  alias la="eza"
  alias l="ex"
  alias h="history 1 | grep"
  alias rm="rm -rf"
  alias cp="cp -r"
  alias zathura="zathura --mode fullscreen"
  alias nv="nvim"
  alias ip='ip --color=auto'
  alias myip='curl -Z ifconfig.me; echo ""' 
  alias myip4='dig @resolver4.opendns.com myip.opendns.com +short -4'
  alias myip6='dig @ns1.google.com TXT o-o.myaddr.l.google.com +short -6'
  alias ..="cd .."
  alias ...="cd ../.."
  alias ....="cd ../../.."
  alias .....="cd ../../../.."
  alias gitclown="git clone"
  alias pst="pomodoro start" 
end

if test -f ~/.profile
 bash -c 'source ~/.profile'
end

if test -f /etc/profile
 bash -c 'source /etc/profile'
end

set -x PATH ~/.cargo/bin ~/.local/bin ~//bin /usr/local/bin /usr/local/sbin /usr/bin /bin /sbin /usr/sbin $PATH
set -x PATH "$PATH:$(go env GOBIN):$(go env GOPATH)/bin"
set -x PATH "$HOME/.local/bin:$PATH"
set -Ux fish_user_paths $HOME/.nix-profile/bin $fish_user_paths


set XDG_DOWNLOAD_DIR ~/Downloads
set SHELL /usr/bin/fish
set TERMINAL /usr/bin/alacritty
set GTK_THEME BlackAndWhite
# fenv + rye: source "$HOME/.rye/env"
if status --is-interactive
  # source /etc/profile
  fenv source /etc/profile
end

nvm use latest -s

# zoxide init fish | source
eval "$(zoxide init --cmd cd fish)"
