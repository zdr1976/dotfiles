# zmodload zsh/zprof
# If not running interactively, don't do anything.
case $- in
    *i*) ;;
    *) return;;
esac

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
HISTSIZE=10000
SAVEHIST=10000
# history saving options
setopt histignorespace # Ignore commands that start with space.
setopt histignorealldups # Never add duplicate entries.
setopt histreduceblanks # Remove unnecessary blank lines.
setopt incappendhistory # Immediately append to the history file.

# Append to the history file, don't overwrite it.
setopt appendhistory

# Prompt expansion
setopt promptsubst

# Globbing characters
unsetopt nomatch

# Command-line completion (Docker)
# - mkdir -p ~/.zsh/completions
# - curl -L https://raw.githubusercontent.com/docker/compose/1.29.2/contrib/completion/zsh/_docker-compose -o ~/.zsh/completions/_docker-compose
# - curl -L https://git.kernel.org/pub/scm/git/git.git/plain/contrib/completion/git-completion.zsh -o ~/.zsh/completions/_git
fpath=(~/.zsh/completions $fpath)

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

# Map Ctrl+r to search in history
bindkey "^R" history-incremental-search-backward
# History search
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
# setup key accordingly
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[2~" overwrite-mode
bindkey "^[[3~" delete-char
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
bindkey "^[[C" forward-char
bindkey "^[[D" backward-char

# Easy directory navigation. Don't need to type cd to change directories.
setopt autocd autopushd pushdminus pushdsilent pushdtohome pushdignoredups

# Disable paste highlighting.
zle_highlight+=(paste:none)

# Default editor.
export EDITOR=vim

# Add local ~/bin and ~/.local/bin to PAT
#export PATH=~/bin:~/.local/bin:$PATH

# Only apply for MacOS system.
if [ "$OS" = "OSX" ]; then
    export CLICOLOR=1
    export LSCOLORS="GxFxCxDxBxegedabagaced"
    export PATH=$(/usr/local/bin/brew --prefix)/bin:$PATH
    # Let brew know that we are running on full 64-bit system.
    export ARCHFLAGS="-arch x86_64"
    zstyle ':completion:*' list-colors $LSCOLORS
elif [ "$OS" = "LINUX" ]; then
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

# Set Git branch in BASH prompt.
parse_git_branch() {
    # Uncoment this line if your system is not UTF-8 ready.
    # git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ git:\1/'
    # Uncomment this on UTF-8 compatible system.
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ ⎇  \1/'
}

# Set k8s context in BASH prompt
_old_parse_k8s_context() {
    context=`kubectl config view --output 'jsonpath={..current-context}'`
    namespace=`kubectl config view --output 'jsonpath={..namespace}'`
    if [[ -n $context ]] && [[ -n $namespace ]]; then
        echo -n " (k8s:$context/$namespace)"
    # elif [[ -n $context ]] ; then
    #     echo -n " (k8s:$context)"
    fi
}
# NEW: Set kubernetes context in BASH prompot
parse_k8s_context() {
  if [ -z $KUBECONFIG ]; then
    return
  fi

  local context namespace
  context=$(yq e '.current-context // ""' "$KUBECONFIG")
  namespace=$(yq e "(.contexts[] | select(.name == \"$context\").context.namespace) // \"\"" "$KUBECONFIG")

  if [[ -n $context ]] && [[ -n $namespace ]]; then
    echo -n " (k8s:$context/$namespace)"
  # elif [[ -n $context ]] ; then
  #   echo -n " (k8s:$context)"
  fi
}

# Load colors
autoload -U colors && colors
# Prompt with Git branch if available.
local git_branch='%{$fg_bold[blue]%}$(parse_git_branch)'
local k8s_context='%{$fg_bold[magenta]%}$(parse_k8s_context)'
# PS1="%{$fg_bold[green]%}%m %{$fg_bold[yellow]%}%(3~|.../%2~|%~)${git_branch} %{$fg_bold[yellow]%}% \$ %{$reset_color%}%{$fg[white]%}"
PS1="%{$fg_bold[green]%}%m %{$fg_bold[yellow]%}%(3~|.../%2~|%~)${git_branch}${k8s_context} %{$fg_bold[yellow]%}% \$ %{$reset_color%}%{$fg[white]%}"

# Some nice aliases to have
alias diff='colordiff'
alias git-cloc='git ls-files | xargs cloc'
alias sup='sudo su -'
#alias ls='ls --color --group-directories-first'
#alias ll='ls -lA'
alias ls='exa'
alias ll='exa -alh'
alias tree='exa --tree'
alias k='kubectl'
alias g='git'
# dh print history of visited directories. Use cd -number to go to selected folder.
alias dh='dirs -v'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Source another Aliases from external file (if exists).
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

# Project DIR
CDPATH=.:~:~/Projects/Work:~/Projects/Personal

# GO LANG
export GOPATH=$HOME/go
if [ "$OS" = "LINUX" ]; then
    export GOROOT=$HOME/bin/go
elif [ "$OS" = "OSX" ]; then
    export GOROOT=$(brew --prefix)/opt/go/libexec/go
fi
#export PATH=$GOROOT/bin:$PATH

# PYTHON
# Temporarily turn off restriction for pip
gpip(){
    PIP_REQUIRE_VIRTUALENV="" pip "$@"
}

gpip3(){
    PIP_REQUIRE_VIRTUALENV="" pip3 "$@"
}

# Kubernetes
# Check if 'kubectl' is a command in $PATH
if [ $commands[kubectl-disabled] ]; then
  # Placeholder 'kubectl' shell function:
  # Will only be executed on the first call to 'kubectl'
  kubectl() {
    # Remove this function, subsequent calls will execute 'kubectl' directly
    unfunction "$0"
    # Load auto-completion
    source <(kubectl completion zsh)
    # Execute 'kubectl' binary
    $0 "$@"
  }
fi

# k8s-kx
kx() {
    eval $(k8s-kx)
}


kexec() {
    kubectl exec -it "$1" -- sh
}

# NPM
NPM_PACKAGES="${HOME}/.npm-packages"
export PATH="$PATH:$NPM_PACKAGES/bin"
# Preserve MANPATH if you already defined it somewhere in your config.
# Otherwise, fall back to `manpath` so we can inherit from `/etc/manpath`.
export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"
# Tell npm where to store globally installed packages
# $ npm config set prefix "${HOME}/.npm-packages"

# Check if 'npm' is a command in $PATH
if [ $commands[npm-disabled] ]; then
  # Placeholder 'npm' shell function:
  # Will only be executed on the first call to 'npm'
  npm() {
    # Remove this function, subsequent calls will execute 'kubectl' directly
    unfunction "$0"
    # Load auto-completion
    source <(npm completion)
    # Execute 'npm' binary
    $0 "$@"
  }
fi

# Powerline
#if [ -f /usr/share/powerline/bindings/bash/powerline.sh ]; then
#  powerline-daemon -q
#  POWERLINE_BASH_CONTINUATION=1
#  POWERLINE_BASH_SELECT=1
#  source /usr/share/powerline/bindings/bash/powerline.sh
#fi

# Starship
if [ $commands[starship] ]; then
    eval "$(starship init zsh)"
fi

# Uncomment this line if your terminal doesn't propagate 256 colors support.
#TERM=xterm-256color
# zprof
