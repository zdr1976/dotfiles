# If not running interactively, don't do anything.CDPATH
case $- in
    *i*) ;;
    *) return;;
esac

# Simple OS detection in Bash using $OSTYPE.
OS=`uname -s`
case "$OSTYPE" in
    darwin*)
	    OS="OSX"
        ;;
    linux*)
        OS="LINUX"
        ;;
    *)
        OS="UNKNOWN"
        ;;
esac

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1) man page.
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# https://www.tummy.com/blogs/2006/01/19/my-first-few-days-with-zsh/
# http://zsh.sourceforge.net/Doc/Release/Options.html#Description-of-Options
# https://github.com/ricbra/zsh-config/blob/master/zshrc
# Don't put duplicate lines or lines starting with space in the history.
setopt histignorespace
setopt histignorealldups

# Append to the history file, don't overwrite it.
setopt appendhistory

# Prompt expansion
setopt promptsubst

# Globbing characters
unsetopt nomatch

# Enable autocompletation.
setopt completealiases
autoload -U compinit && compinit
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
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
[[ -n "$key[Up]"   ]] && bindkey -- "$key[Up]"   up-line-or-beginning-search
[[ -n "$key[Down]" ]] && bindkey -- "$key[Down]" down-line-or-beginning-search

# Easy directory navigation. Don't need to type cd to change directories.
setopt autocd autopushd pushdminus pushdsilent pushdtohome pushdignoredups

# Disable paste highlighting.
zle_highlight+=(paste:none)

# Default editor.
export EDITOR=vim

# Add local ~/bin and ~/.local/bin to PAT
export PATH=~/bin:~/.local/bin:$PATH

# Only apply for MacOS system.
if [ "$OS" = "OSX" ]; then
    export CLICOLOR=1
    export LSCOLORS=GxFxCxDxBxegedabagaced
    export PATH=$(/usr/local/bin/brew --prefix)/bin:$PATH
    # Let brew know that we are running on full 64-bit system.
    export ARCHFLAGS="-arch x86_64"
fi

# Set Git branch in BASH prompt.
parse_git_branch() {
    # Uncoment this line if your system is not UTF-8 ready.
    # git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ git:\1/'
    # Uncomment this on UTF-8 compatible system.
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ ⎇  \1/'
}

# Set k8s context in BASH prompt
parse_k8s_context() {
    cat ~/.kube/config | grep "current-context:" | sed "s/current-context: //"
}

# Load colors
autoload -U colors && colors
# Prompt with Git branch if available.
local git_branch='%{$fg_bold[blue]%}$(parse_git_branch)'
PS1="%{$fg_bold[green]%}%m %{$fg_bold[yellow]%}%(3~|.../%2~|%~)${git_branch} %{$fg_bold[yellow]%}% \$ %{$reset_color%}%{$fg[white]%}"

# Some nice aliases to have
alias diff='colordiff'
alias git-cloc='git ls-files | xargs cloc'
alias sup='sudo su -'
alias ls='ls --color'
alias ll='ls -lA'
alias dh='dirs -v'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Source another Aliases from external file (if exists).
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

# GO LANG
export GOPATH=$HOME/go
if [ "$OS" = "LINUX" ]; then
    export GOROOT=$HOME/bin/go
elif [ "$OS" = "OSX" ]; then
    export GOROOT=$(brew --prefix)/opt/go/libexec/go
fi
export PATH=$GOROOT/bin:$PATH

# PYTHON
# pip should only run if there is a virtualenv currently activated
export PIP_REQUIRE_VIRTUALENV=true
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Projects/Python
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
export VIRTUALENVWRAPPER_VIRTUALENV=~/.local/bin/virtualenv
if [ "$OS" = "OSX" ]; then
    if [ -f $(/usr/local/bin/brew --prefix)/bin/virtualenvwrapper.sh ]; then
	    . $(/usr/local/bin/brew --prefix)/bin/virtualenvwrapper.sh
    fi
elif [ "$OS" = "LINUX" ]; then
    if [ -f /etc/bash_completion.d/virtualenvwrapper ]; then
	    . /etc/bash_completion.d/virtualenvwrapper
    elif [ -f /etc/profile.d/virtualenvwrapper.sh ]; then
	    . /etc/profile.d/virtualenvwrapper.sh
    elif [ -f ~/.local/bin/virtualenvwrapper.sh ]; then
	    . ~/.local/bin/virtualenvwrapper.sh
    fi
fi

# Project DIR
CDPATH=.:~:~/Projects/Work:~/Projects/Personal

# Temporarily turn off restriction for pip
gpip(){
    PIP_REQUIRE_VIRTUALENV="" pip "$@"
}

gpip3(){                                                                        
    PIP_REQUIRE_VIRTUALENV="" pip3 "$@"                                         
}

# k8s
#if [ -x "$(command -v kubectl)" ]; then
#    source <(kubectl completion zsh)
#fi

# k8s - Lazy load
# zsh completion takes a long time to load
# https://github.com/kubernetes/kubernetes/issues/59078
function kubectl() {
    if ! type __start_kubectl >/dev/null 2>&1; then
        source <(command kubectl completion zsh)
    fi

    command kubectl "$@"
}

# Powerline
#if [ -f /usr/share/powerline/bindings/bash/powerline.sh ]; then
#  powerline-daemon -q
#  POWERLINE_BASH_CONTINUATION=1
#  POWERLINE_BASH_SELECT=1
#  source /usr/share/powerline/bindings/bash/powerline.sh
#fi

# Uncomment this line if your terminal doesn't propagate 256 colors support.
#TERM=xterm-256color
