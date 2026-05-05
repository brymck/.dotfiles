#-------------------------------------------------------------------------------
# Homebrew
#-------------------------------------------------------------------------------
if test -x /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
end

#-------------------------------------------------------------------------------
# Aliases
#-------------------------------------------------------------------------------
if status is-interactive
    # Git
    abbr -a gst 'git status'
    abbr -a g git
    abbr -a ga 'git add'
    abbr -a gaa 'git add --all'
    abbr -a gcb 'git checkout -b'
    abbr -a gbm 'git branch --move'
    abbr -a gc 'git commit --verbose'
    abbr -a gcb 'git checkout -b'
    abbr -a gcm 'git checkout $(git_main_branch)'
    abbr -a gcmsg 'git commit --message'
    abbr -a gcn 'git commit --verbose --no-edit'
    abbr -a 'gcn!' 'git commit --verbose --no-edit --amend'
    abbr -a gco 'git checkout'
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
end

#-------------------------------------------------------------------------------
# ASDF
#-------------------------------------------------------------------------------
if test -z $ASDF_DATA_DIR
    set _asdf_shims "$HOME/.asdf/shims"
else
    set _asdf_shims "$ASDF_DATA_DIR/shims"
end
if not contains $_asdf_shims $PATH
    set -gx --prepend PATH $_asdf_shims
end
set --erase _asdf_shims
