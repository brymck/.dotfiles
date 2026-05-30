#-------------------------------------------------------------------------------
# Homebrew
#-------------------------------------------------------------------------------
if test -x /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
else if test -x /home/linuxbrew/.linuxbrew/bin/brew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end
if command -q brew
    set -l brew_prefix (brew --prefix)
end

#-------------------------------------------------------------------------------
# Node
#-------------------------------------------------------------------------------
if command -q fnm
    eval (fnm env)
end

#-------------------------------------------------------------------------------
# Aliases
#-------------------------------------------------------------------------------
if status is-interactive
    # Git
    abbr -a g git
    abbr -a ga 'git add'
    abbr -a gaa 'git add --all'
    abbr -a gcb 'git checkout -b'
    abbr -a gbm 'git branch --move'
    abbr -a gc 'git commit --verbose'
    abbr -a gca 'git commit --amend'
    abbr -a gcan 'git commit --amend --no-edit'
    abbr -a gcb 'git checkout -b'
    abbr -a gcm 'git checkout $(git_main_branch)'
    abbr -a gcmsg 'git commit --message'
    abbr -a gcn 'git commit --verbose --no-edit'
    abbr -a 'gcn!' 'git commit --verbose --no-edit --amend'
    abbr -a gco 'git checkout'
    abbr -a gcp 'git cherry-pick'
    abbr -a gd 'git diff'
    abbr -a gdca 'git diff --cached'
    abbr -a gl 'git pull'
    abbr -a gp 'git push'
    abbr -a gpf 'git push --force-with-lease --force-if-includes'
    abbr -a grbm 'git rebase $(git_main_branch)'
    abbr -a grh 'git reset'
    abbr -a grhh 'git reset --hard'
    abbr -a grhs 'git reset --soft'
    abbr -a gst 'git status'
    abbr -a gsta 'git stash push'
    abbr -a gstp 'git stash pop'

    # tmux
    abbr -a t tmux

    # Vim
    abbr -a v nvim
    abbr -a vim nvim
end

if command -q zoxide
    zoxide init fish | source
end
