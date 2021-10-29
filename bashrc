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

# Dynamic bash prompt
# - Call the function promter() before PS1 for dynamic update
PROMPT_COMMAND=prompter

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it.
shopt -s histappend

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1) man page.
HISTSIZE=1000
HISTFILESIZE=100000

# Shorten the depth of directory
PROMPT_DIRTRIM=2

# Default editor.
export EDITOR=vim

# Add local ~/bin and ~/.local/bin to PATH
export PATH=~/bin:~/.local/bin:$PATH

# Only apply for MacOS system.
if [ "$OS" == "OSX" ]; then
    export CLICOLOR=1
    export LSCOLORS="GxFxCxDxBxegedabagaced"
    export PATH=$(/usr/local/bin/brew --prefix)/bin:$PATH
    # Let brew know that we are running on full 64-bit system.
    export ARCHFLAGS="-arch x86_64"
fi

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Colors http://misc.flogisoft.com/bash/tip_colors_and_formatting
BOLD_GREEN="\e[1;32m"
BOLD_YELLOW="\e[1;33m"
BOLD_RED="\e[1;31m"
BOLD_WHITE="\e[1;37m"
BOLD_BLUE="\e[1;34m"
BOLD_PURPLE="\e[1;35m"
BOLD_CYAN="\e[1;36m"
RESET_TEXT="\e[1;0m"

# Prompt with Git branch if available.
#PS1="\[$BOLD_GREEN\]\h\[$BOLD_YELLOW\] \w\[$BOLD_BLUE\]\$(parse_git_branch)\[$BOLD_YELLOW\] $ \[$RESET_TEXT\]"
# Prompt with Git branche and K8s curent-context and namespace if available
#PS1="\[$BOLD_GREEN\]\h\[$BOLD_YELLOW\] \w\[$BOLD_BLUE\]\$(parse_git_branch)$(parse_k8s_context)\[$BOLD_YELLOW\] $ \[$RESET_TEXT\]"
# Prompt without Git branch.
#PS1="\[$BOLD_GREEN\]\h\[$BOLD_YELLOW\] \w $ \[$RESET_TEXT\]"
prompter() {
    # Choice one from examples above
    PS1="\[$BOLD_GREEN\]\h\[$BOLD_YELLOW\] \w\[$BOLD_BLUE\]\$(parse_git_branch)\[$BOLD_PURPLE\]\$(parse_k8s_context)\[$BOLD_YELLOW\] $ \[$RESET_TEXT\]"

    # Python venv
    if [[ -n $VIRTUAL_ENV ]]; then
        PS1="(`basename \"$VIRTUAL_ENV\"`) $PS1"
    fi

    export PS1
}

# Set Git branch in BASH prompt.
parse_git_branch() {
	# Uncoment this line if your system is not UTF-8 ready.
	# git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ git:\1/'
	# Uncomment this on UTF-8 compatible system.
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ ⎇  \1/'
}

# Set kubernetes context in BASH prompt
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

# Some nice aliases to have
alias diff='colordiff'
alias git-cloc='git ls-files | xargs cloc'
alias sup='sudo su -'
alias ls='ls --color'
alias ll='ls -lA'

# Source another Aliases from external file (if exists).
if [ -f ~/.aliases ]; then
	. ~/.aliases
fi

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc or /etc/profile).
# If not sources particular file.
if ! shopt -oq posix; then
	# Linux system.
	if [ "$OS" == "LINUX" ]; then
		if [ -f /usr/share/bash-completion/bash_completion ]; then
			. /usr/share/bash-completion/bash_completion
		elif [ -f /etc/bash_completion ]; then
			. /etc/bash_completion
		fi
	# MacOS system.
	elif [ "$OS" == "OSX" ]; then
		if [ -f $(brew --prefix)/etc/bash_completion ]; then
			. $(brew --prefix)/etc/bash_completion
		fi
	fi
fi

# Project DIR
CDPATH=.:~:~/Projects/Work:~/Projects/Personal

# GO LANG
export GOPATH=$HOME/go
if [ "$OS" == "LINUX" ]; then
	export GOROOT=$HOME/bin/go
elif [ "$OS" == "OSX" ]; then
	export GOROOT=$(brew --prefix)/opt/go/libexec/go
fi
export PATH=$PATH:$GOROOT/bin

# PYTHON
# - Temporarily turn off restriction for pip.
gpip(){
	PIP_REQUIRE_VIRTUALENV="" pip "$@"
}

gpip3(){
    PIP_REQUIRE_VIRTUALENV="" pip3 "$@"
}


# Kubernetes
if [ -x "$(command -v kubectl)" ]; then
    source <(kubectl completion bash)
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

if [ -x "$(command -v npm)" ]; then
    source <(npm completion)
fi

# Powerline
#if [ -f `which powerline-daemon` ]; then
#    powerline-daemon -q
#    POWERLINE_BASH_CONTINUATION=1
#    POWERLINE_BASH_SELECT=1
#    . /usr/share/powerline/bash/powerline.sh
#fi

# Uncomment this line if your terminal doesn't propagate 256 colors support.
# TERM=xterm-256color
