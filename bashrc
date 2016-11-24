# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return;;
esac

# OS detection
OS=`uname -s`

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=10000

EDITOR=vim

# Only for MacOS
if [ "$OS" == "Darwin" ]; then
	export CLICOLOR=1
	export LSCOLORS=GxFxCxDxBxegedabagaced
	export PATH=$(/usr/local/bin/brew --prefix)/bin:$PATH
	# Set architecture flags
	export ARCHFLAGS="-arch x86_64"
fi

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Git branch in prompt.
parse_git_branch() {
	# git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ git:\1/'
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ ⎇  \1/'
}

# Colors http://misc.flogisoft.com/bash/tip_colors_and_formatting
BLDGRN="\e[1;32m"
BLDYLW="\e[1;33m"
BLDRED="\e[1;31m"
BLDWHT="\e[1;37m"
BLDBLU="\e[1;34m"
BLDPUR="\e[1;35m"
BLDCYN="\e[1;36m"
TXTRST="\e[1;0m"

# With Git
PS1="\[$BLDGRN\]\h\[$BLDYLW\] \w\[$BLDBLU\]\$(parse_git_branch)\[$BLDYLW\] $ \[$TXTRST\]"
# Without Git
#PS1="\[$BLDGRN\]\h\[$BLDYLW\] \w $ \[$TXTRST\]"

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
	# MacOS with brew installed
	if [ "$OS" == "Darwin" ]; then
		if [ -f $(brew --prefix)/etc/bash_completion ]; then
			. $(brew --prefix)/etc/bash_completion
		fi
	fi
fi

# GO LANG
export GOPATH=$HOME/Projects/GO
if [ "$OS" == "Darwin" ]; then
		export GOROOT=$(brew --prefix)/opt/go/lbexec/go
elif [ "$OS" == "Linux" ]; then
	export GOROOT=$HOME/bin/go
fi
export PATH=~/bin:$PATH:$GOROOT/bin

# PYTHON
# pip should only run if there is a virtualenv currently activated
export PIP_REQUIRE_VIRTUALENV=true
export WORKON_HOME=~/.virtualenvs
if [ "$OS" == "Darwin" ]; then
	if [ -f $(/usr/local/bin/brew --prefix)/bin/virtualenvwrapper.sh ]; then
		. $(/usr/local/bin/brew --prefix)/bin/virtualenvwrapper.sh
	fi
elif [ "$OS" == "Linux" ]; then
	if [ -f /etc/bash_completion.d/virtualenvwrapper ]; then
		. /etc/bash_completion.d/virtualenvwrapper
	fi
fi

# Temporarily turn off restriction for pip
gpip(){
	PIP_REQUIRE_VIRTUALENV="" pip "$@"
}


# Uncomment if your terminal doesn't propagate that nut support 256 colors
#TERM=xterm-256color
