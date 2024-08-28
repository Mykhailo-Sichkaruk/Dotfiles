# Aliases
alias g 'git'
complete -c g -a 'git'
alias gst 'git status'
complete -c gst -a 'git-status'
alias gl 'git pull'
complete -c gl -a 'git-pull'
alias gup 'git fetch; and git rebase'
complete -c gup -a 'git-fetch'
alias gp 'git push'
complete -c gp -a 'git-push'
function gdv
    git diff -w $argv | view -
end
complete -c gdv -a 'git-diff'
alias gc 'git commit -v'
complete -c gc -a 'git-commit'
alias gca 'git commit -v -a'
complete -c gca -a 'git-commit'
alias gco 'git checkout'
complete -c gco -a 'git-checkout'
alias gcm 'git checkout master'
alias gb 'git branch'
complete -c gb -a 'git-branch'
alias gba 'git branch -a'
complete -c gba -a 'git-branch'
alias gcount 'git shortlog -sn'
complete -c gcount -a 'git'
alias gcp 'git cherry-pick'
complete -c gcp -a 'git-cherry-pick'
alias glg 'git log --stat --max-count=5'
complete -c glg -a 'git-log'
alias glgg 'git log --graph --max-count=5'
complete -c glgg -a 'git-log'
alias gss 'git status -s'
complete -c gss -a 'git-status'
alias ga 'git add'
complete -c ga -a 'git-add'
alias gm 'git merge'
complete -c gm -a 'git-merge'
alias grh 'git reset HEAD'
alias grhh 'git reset HEAD --hard'

# Git and svn mix
alias git-svn-dcommit-push 'git svn dcommit; and git push github master:svntrunk'
complete -c git-svn-dcommit-push -a 'git'

alias gsr 'git svn rebase'
alias gsd 'git svn dcommit'

# Function to return the current branch name
function current_branch
    set ref (git symbolic-ref HEAD ^/dev/null)
    if test -n "$ref"
        echo (string replace --regex -- ^refs/heads/ "" $ref)
    end
end

# Function to return the current repository
function current_repository
    set ref (git symbolic-ref HEAD ^/dev/null)
    if test -n "$ref"
        echo (git remote -v | cut -d':' -f 2)
    end
end

# Aliases that use the above functions
alias ggpull 'git pull origin (current_branch)'
complete -c ggpull -a 'git'
alias ggpush 'git push origin (current_branch)'
complete -c ggpush -a 'git'
alias ggpnp 'git pull origin (current_branch); and git push origin (current_branch)'
complete -c ggpnp -a 'git'
