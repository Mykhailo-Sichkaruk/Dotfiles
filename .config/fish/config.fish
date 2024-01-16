if status is-interactive
    # Commands to run in interactive sessions can go here
  set fish_cursor_insert line
  set fish_greeting
  fish_config theme choose "Dracula Official"
  function fish_mode_prompt; end

  alias nowtime='date +"%T"' #this will show the current time in 24hrs format as HH:MM:SS
  alias nowdate='date +"%d-%m-%Y"' #this will show the current date in format dd-MM-YY
  alias cls="clear"
  alias e="exa -Fab --group-directories-first --icons"
  alias ex="exa -Fab --group-directories-first --icons -lTL 1 --no-time --git --no-user"
  alias ls="ls --color -L"
  alias la="ex"
  alias l="e"
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
  alias config="git --git-dir=$HOME/.config/ --work-tree=$HOME"

end

if test -f ~/.profile
 bash -c 'source ~/.profile'
end

# thefuck --alias | source
nvm use v20.9.0
set -x PATH /home/misha/.nvm/versions/node/v20.9.0/bin /home/misha/.npm-global/bin /usr/local/go/bin /home/misha/.cargo/bin /home/misha/.local/bin /home/misha/bin /usr/local/bin /usr/bin /bin /sbin /usr/sbin $PATH
alias suposle="sudo"


# pnpm
set -gx PNPM_HOME "/home/misha/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
