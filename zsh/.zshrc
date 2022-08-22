# https://xebia.com/blog/profiling-zsh-shell-scripts/
# zmodload zsh/zprof

# Simple OS detection in Bash using $OSTYPE.
OS="UNKNOWN"
case "$OSTYPE" in
    darwin*)
	    OS="OSX"
        ;;
    linux*)
        OS="LINUX"
        ;;
    dragonfly*|freebsd*|netbsd*|openbsd*)
        OS="BSD"
        ;;
    *)
        OS="UNKNOWN"
        ;;
esac

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1) man page.
HISTFILE=~/.zsh_history
HISTSIZE=2000
SAVEHIST=10000
# Ignore commands that start with space.
setopt histignorespace
# Never add duplicate entries.
setopt histignorealldups
# Remove unnecessary blank lines.
setopt histreduceblanks
# Immediately append to the history file.
setopt incappendhistory
# Append to the history file, don't overwrite it.
setopt appendhistory

# Prompt expansion
setopt promptsubst

# Globbing characters
unsetopt nomatch

# Map Ctrl+r to search in history
bindkey "^R" history-incremental-search-backward
# Cycle through history based on characters already typed on the line
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
# Set vi/vim binding
#bindkey -v
# setup key accordingly
bindkey "^[[H" beginning-of-line # Home
bindkey "^[[F" end-of-line # End
bindkey "^[[2~" overwrite-mode # Insert
bindkey "^[[3~" delete-char # Del
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down
bindkey "^[[C" forward-char # Left
bindkey "^[[D" backward-char # Right

# Switching directories for lazy people
setopt autocd
# See: http://zsh.sourceforge.net/Intro/intro_6.html
setopt autopushd pushdminus pushdsilent pushdtohome pushdignoredups

# Disable paste highlighting.
zle_highlight+=(paste:none)

# A colon-separated list of directories used as a search path for the cd builtin command.
CDPATH=.:~:~/Projects/Work:~/Projects/Personal

# Default editor.
export EDITOR=vim

# Add local ~/bin and ~/.local/bin to PAT
export PATH=~/bin:~/.local/bin:$PATH

# Only apply for MacOS system.
if [ "$OS" = "OSX" ]; then
    export CLICOLOR=1
    export LSCOLORS="GxFxCxDxBxegedabagaced"
    eval "$(/opt/homebrew/bin/brew shellenv)"
    # coreutils (command like GNU ls) need to be installed via brew first.
    export PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
    # Some cmd aplication store config in .config directory.
    mkdir -p .config
    zstyle ':completion:*' list-colors $LSCOLORS
    # Load ssh keys from keychain
    ssh-add --apple-load-keychain
elif [ "$OS" = "LINUX" ]; then
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

# Helper function to set Git branch in shell prompt.
parse_git_branch() {
    # Uncoment this line if your system is not UTF-8 ready.
    # git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ git:\1/'
    # Uncomment this on UTF-8 compatible system.
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ ⎇  \1/'
}

# Helper function to set kubernetes context in shell prompt.
parse_k8s_context() {
  if [ -z $KUBECONFIG ]; then
    return
  fi

  local context namespace
  context=$(yq e '.current-context // ""' "$KUBECONFIG")
  namespace=$(yq e "(.contexts[] | select(.name == \"$context\").context.namespace) // \"\"" "$KUBECONFIG")

  if [[ -n $context ]] && [[ -n $namespace ]]; then
    echo -n " (k8s:$context/$namespace)"
  elif [[ -n $context ]] ; then
    echo -n " (k8s:$context)"
  fi
}

# Load colors
autoload -U colors && colors

# Set shell prompt.
if [ $commands[starship] ]; then
    eval "$(starship init zsh)"
else
    # Prompt with Git branch if available.
    local git_branch='%{$fg_bold[blue]%}$(parse_git_branch)'
    local k8s_context='%{$fg_bold[magenta]%}$(parse_k8s_context)'
    PS1="%{$fg_bold[green]%}%m %{$fg_bold[yellow]%}%(3~|.../%2~|%~)${git_branch}${k8s_context} %{$fg_bold[yellow]%}% \$ %{$reset_color%}%{$fg[white]%}"
fi

# Some nice aliases to have
alias diff='colordiff'
alias git-cloc='git ls-files | xargs cloc'
alias sup='sudo -i'
alias ls='ls --color --group-directories-first'
alias ll='ls -lA'
# dh print history of visited directories. Use cd -number to go to selected folder.
alias dh='dirs -v'
#alias ls='exa'
#alias ll='exa -alh'
#alias tree='exa --tree'
alias k='kubectl'
alias g='git'

# Source another Aliases from external file (if exists).
if [ -f ~/.aliases ]; then
    . "$HOME"/.aliases
fi

# Create global directory
[ -d ~/.zsh_completions ] || mkdir ~/.zsh_completions
#

# Select from multiple k8s clusters configurations.
kc() {
    local k8s_config
    k8s_config=$(find "$HOME"/.kube/ -type f -not -path "$HOME/.kube/old-config/*" \( -iname '*.yaml' -o -iname '*.yml' -o -iname '*.conf' -o -iname 'config' \) | fzf)
    export KUBECONFIG="$k8s_config"
}

# alias for `kubectl exec`
kexec() {
    kubectl exec -it "$1" -- sh
}

# Node version manager
# Install:
# - Linux install via curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
# - Mac install via brew install nvm
mkdir -p ~/.nvm
export NVM_DIR="$HOME/.nvm"
if [ "$OS" == "OSX" ]; then
    [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"  # This loads nvm
    [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
else
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completions" ] && \. "$NVM_DIR/bash_completions"  # This loads nvm bash_completions
fi

# Generate npm completetion.
if [ $commands[npm] ]; then
    [ -s ~/.zsh_completions/_npm ] || npm completion > ~/.zsh_completions/_npm
fi

# Generate kubectl completetion.
if [ $commands[kubectl] ]; then
    [ -s ~/.zsh_completions/_kubectl ] || kubectl completion zsh > ~/.zsh_completions/_kubectl
fi

# Command-line completion
# - curl -L https://raw.githubusercontent.com/docker/compose/1.29.2/contrib/completion/zsh/_docker-compose -o ~/.zsh_completions/_docker-compose
# - curl -L https://git.kernel.org/pub/scm/git/git.git/plain/contrib/completion/git-completion.zsh -o ~/.zsh_completions/_git
fpath=(~/.zsh_completions $fpath)
#
# Enable autocompletion.
#setopt completealiases
autoload -Uz compinit && compinit
_comp_options+=(globdots)

zstyle ':completion:*' menu select
# small letters will match small and capital letters
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# capital letters also match small letters
#zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
# case-insensitive matching only if there are no case-sensitive matches
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'


# GO LANG
export GOPATH=$HOME/go
if [ "$OS" = "OSX" ]; then
    export GOROOT=$HOMEBREW_PREFIX/opt/go/libexec
else
    export GOROOT=$HOME/bin/go
fi
export PATH=$GOROOT/bin:$GOPATH:bin:$PATH

# Uncomment this line if your terminal doesn't propagate 256 colors support.
#TERM=xterm-256color
# zprof
