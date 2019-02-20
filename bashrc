# If not running interactively, don't do anything.
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

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it.
shopt -s histappend

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1) man page.
HISTSIZE=10000
HISTFILESIZE=10000

# Shorten the depth of directory
PROMPT_DIRTRIM=1

# Default editor.
export EDITOR=vim

# Only apply for MacOS system.
if [ "$OS" == "OSX" ]; then
	export CLICOLOR=1
	export LSCOLORS=GxFxCxDxBxegedabagaced
	export PATH=$(/usr/local/bin/brew --prefix)/bin:$PATH
	# Let brew know that we are running on full 64-bit system.
	export ARCHFLAGS="-arch x86_64"
fi

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

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
# PS1="\[$BOLD_GREEN\]\h\[$BOLD_YELLOW\] \w\[$BOLD_BLUE\]\$(parse_git_branch) (k8s: $(parse_k8s_context))\[$BOLD_YELLOW\] $ \[$RESET_TEXT\]"
PS1="\[$BOLD_GREEN\]\h\[$BOLD_YELLOW\] \w\[$BOLD_BLUE\]\$(parse_git_branch)\[$BOLD_YELLOW\] $ \[$RESET_TEXT\]"
# Prompt without Git branch.
#PS1="\[$BOLD_GREEN\]\h\[$BOLD_YELLOW\] \w $ \[$RESET_TEXT\]"

# Some nice aliases to have
alias diff='colordiff'
alias git-cloc='git ls-files | xargs cloc'
alias sup='sudo su -'
alias ls='ls --color'
alias ll='ls -lA'

# Source another Aliases from external file (if exists).
if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
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

# GO LANG
export GOPATH=$HOME/go
if [ "$OS" == "LINUX" ]; then
	export GOROOT=$HOME/bin/go
elif [ "$OS" == "OSX" ]; then
	export GOROOT=$(brew --prefix)/opt/go/libexec/go
fi
export PATH=~/bin:$PATH:$GOROOT/bin

# PYTHON
# pip should only run if there is a virtualenv currently activated
export PIP_REQUIRE_VIRTUALENV=true
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Projects/Python
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
export VIRTUALENVWRAPPER_VIRTUALENV=/usr/bin/virtualenv-3
if [ "$OS" == "OSX" ]; then
	if [ -f $(/usr/local/bin/brew --prefix)/bin/virtualenvwrapper.sh ]; then
		. $(/usr/local/bin/brew --prefix)/bin/virtualenvwrapper.sh
	fi
elif [ "$OS" == "LINUX" ]; then
	if [ -f /etc/bash_completion.d/virtualenvwrapper ]; then
		. /etc/bash_completion.d/virtualenvwrapper
	elif [ -f /etc/profile.d/virtualenvwrapper.sh ]; then
		. /etc/profile.d/virtualenvwrapper.sh
	fi
fi

# Temporarily turn off restriction for pip
gpip(){
	PIP_REQUIRE_VIRTUALENV="" pip "$@"
}


# k8s
if [ -x "$(command -v kubectl)" ]; then
    source <(kubectl completion bash)
fi

# Uncomment this line if your terminal doesn't propagate 256 colors support.
#TERM=xterm-256color
