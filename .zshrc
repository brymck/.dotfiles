#-----------------------------------------------------------------------------------------------------------------------
# Compinit
#-----------------------------------------------------------------------------------------------------------------------
# Only check .zcompdump to see if it needs regenerating once per day
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

#-----------------------------------------------------------------------------------------------------------------------
# Terminal
#-----------------------------------------------------------------------------------------------------------------------

export TERM='xterm-256color'

#-----------------------------------------------------------------------------------------------------------------------
# Oh My Zsh
#-----------------------------------------------------------------------------------------------------------------------

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME='robbyrussell'
COMPLETION_WAITING_DOTS='true'
DISABLE_UPDATE_PROMPT='true'

plugins=(
    cp
    git
    iterm2
)

# Load Oh My Zsh
source "$ZSH/oh-my-zsh.sh"

#-----------------------------------------------------------------------------------------------------------------------
# Zplug
#-----------------------------------------------------------------------------------------------------------------------

export ZPLUG_HOME="$(brew --prefix zplug)"
source $ZPLUG_HOME/init.zsh

zplug 'brymck/print-alias'
zplug 'brymck/jetbrains-open'

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load

#-----------------------------------------------------------------------------------------------------------------------
# Environment variables
#-----------------------------------------------------------------------------------------------------------------------

# Use Vim as the default editor
export ALTERNATIVE_EDITOR=
export ALTERNATE_EDITOR=
export EDITOR='vim'
export LANG='en_US.UTF-8'

# Go
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"

# Use Java 17
export JAVA_HOME="$(/usr/libexec/java_home -v 17)"

# Python
if [ -f $HOME/venv/bin/activate ]; then
    source $HOME/venv/bin/activate
fi

#-----------------------------------------------------------------------------------------------------------------------
# Shell extensions
#-----------------------------------------------------------------------------------------------------------------------

# Add syntax highlighting if available
# `brew install zsh-syntax-highlighting`
source "$(brew --prefix zsh-syntax-highlighting)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Add auto-suggestion if available
# `brew install zsh-autosuggestions`
source "$(brew --prefix zsh-autosuggestions)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

#-----------------------------------------------------------------------------------------------------------------------
# Aliases
#-----------------------------------------------------------------------------------------------------------------------

# Personal
alias jb='jetbrains-open --verbose'

# Command line tools
command -v eza > /dev/null && alias ls='eza'

# Kubernetes
# `curl -o $HOME/.kubectl_aliases https://raw.githubusercontent.com/ahmetb/kubectl-alias/master/.kubectl_aliases`
source "$HOME/.kubectl_aliases"

# Gradle
alias gw='./gradlew'

# Homebrew
alias broo='brew update --verbose && env HOMEBREW_NO_AUTO_UPDATE=1 brew upgrade && brew cleanup'

# IntelliJ
alias idp='idea $PWD'

# Jupyter
alias jup="jupyter notebook --notebook-dir $HOME/Notebooks"

# LunarVim
alias vim='lvim'

# Maven
alias jj='java -jar target/$(basename $(pwd)).jar'
alias lvim='/Users/bryan/.local/bin/lvim'
alias mcp='mvn clean package'
alias mcpst='mvn clean package -DskipTests=true'
alias mct='mvn clean test'
alias mp='mvn package'
alias mpst='mvn package -DskipTests=true'
alias mt='mvn test'
alias muct='mvn --update-snapshots clean test'

# pre-commit
alias pcr='pre-commit run'

# SketchUp
alias sketch='(cd /Applications/SketchUp\ 2021/SketchUp.app/Contents/MacOS/ && ./SketchUp)'

# wttr.in
alias wttr="curl 'wttr.in/~Musashino?u'"

if command -v eza >/dev/null; then
    alias ls='eza'
else
    # Use custom directory colors if available
    eval "$(gdircolors ~/.dircolors)"
    alias ls='gls --color=auto'
fi

#-----------------------------------------------------------------------------------------------------------------------
# Path
#-----------------------------------------------------------------------------------------------------------------------

paths=(
    /usr/local/sbin         # system binaries
    "$HOME/bin"             # local executables
    "$HOME/.cargo/bin"      # Cargo
    "$HOME/.local/bin"      # LunarVim
    "$GOBIN"                # Go
)
export PATH="${(j[:])paths}:$PATH"

#-----------------------------------------------------------------------------------------------------------------------
# Rust
#-----------------------------------------------------------------------------------------------------------------------
[ -s "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

#-----------------------------------------------------------------------------------------------------------------------
# Secrets
#-----------------------------------------------------------------------------------------------------------------------

[ -f ~/secrets.zsh ] && source ~/secrets.zsh

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Zoxide
eval "$(zoxide init zsh)"
