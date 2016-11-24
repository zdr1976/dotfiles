# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=10000

EDITOR=vim

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
fi

# GO LANG
export GOPATH=$HOME/Projects/GO
export GOROOT=$HOME/bin/go
export PATH=~/bin:$PATH:$GOROOT/bin

# PYTHON
# pip should only run if there is a virtualenv currently activated
export PIP_REQUIRE_VIRTUALENV=true
WORKON_HOME=~/.virtualenvs
if [ -f /etc/bash_completion.d/virtualenvwrapper ]; then
	. /etc/bash_completion.d/virtualenvwrapper
fi
# Temporarily turn off restriction for pip
gpip(){
	PIP_REQUIRE_VIRTUALENV="" pip "$@"
}

TERM=xterm-256color
