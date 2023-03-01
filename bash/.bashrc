#!/bin/bash

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it.
shopt -s histappend

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1) man page.
HISTSIZE=10000
HISTFILESIZE=100000

# Remap terminal freeze/XOFF to allow forward search in bash history.
# By default Ctrl+s is mappeed to XOFF with this remap Ctrl+p (pause) will
# freeze termional and Ctrl+q still unfreeeze it.
stty stop '^P'

# Shorten the depth of directory
PROMPT_DIRTRIM=2

# A colon-separated list of directories used as a search path for the cd builtin command.
CDPATH=.:~:~/Projects/Work:~/Projects/Personal

# Default editor.
export EDITOR=vim

# Add local ~/bin to PATH
export PATH=~/bin:$PATH

# MacOS ls show colors only if the CLICOLOR environment variable is set or if -G is passed on the command line.
export CLICOLOR=1
# The actual colors are configured through the LSCOLORS environment variable (built-in defaults are used if this variable is not set).
export LSCOLORS="GxFxCxDxBxegedabagaced"

# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"
# Prefer GNU command (like ls) instead of MacOS. Coreutils package need to be installed via brew first (brew install coreutils).
BREW_PREFIX="$(brew --prefix)"
export PATH="$BREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
export PATH="$BREW_PREFIX/opt/gnu-tar/libexec/gnubin:$PATH"
#export PATH="$BREW_PREFIX/opt/openjdk@17/bin:$PATH"

# Some application store configuration in ~/.config directory.
mkdir -p ~/.config
# Create local bash completion directory if not already exists. This is used for kubernetes and npm completion files here.
[ -d ~/.bash_completions ] || mkdir ~/.bash_completions

# Fix locales
if [[ -z "$LC_ALL" ]]; then
    export LC_ALL='en_IE.UTF-8'
fi

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Set shell prompt to `starship` if installed.
if [ -x "$(command -v starship)" ]; then
    eval "$(starship init bash)"
else
    # Dynamic bash prompt
    # - Call the function promter() before PS1 for dynamic update
    PROMPT_COMMAND=prompter
fi

# Dynamic updater for PS1.
prompter() {
    # Colors http://misc.flogisoft.com/bash/tip_colors_and_formatting
    BOLD_GREEN="\e[1;32m"
    BOLD_YELLOW="\e[1;33m"
    # BOLD_RED="\e[1;31m"
    # BOLD_WHITE="\e[1;37m"
    BOLD_BLUE="\e[1;34m"
    BOLD_PURPLE="\e[1;35m"
    # BOLD_CYAN="\e[1;36m"
    RESET_TEXT="\e[1;0m"

	# Uncoment this line if your system is not UTF-8 ready.
    # PS1="\[$BOLD_GREEN\]@\h\[$BOLD_YELLOW\] \w\[$BOLD_BLUE\]\$(parse_git_branch)\[$BOLD_PURPLE\]\$(parse_k8s_context)\[$BOLD_YELLOW\] $ \[$RESET_TEXT\]"
    # Uncomment this on UTF-8 compatible system.
    PS1="\[$BOLD_GREEN\]@\h\[$BOLD_YELLOW\] \w\[$BOLD_BLUE\]\$(parse_git_branch)\[$BOLD_PURPLE\]\$(parse_k8s_context)\[$BOLD_YELLOW\] → \[$RESET_TEXT\]"

    # Python venv
    if [[ -n $VIRTUAL_ENV ]]; then
        PS1="$(basename "$VIRTUAL_ENV") $PS1"
    fi

    export PS1
}

# Helper function to set Git branch in shell prompt.
parse_git_branch() {
	# Uncomment this line if your system is not UTF-8 ready.
	# git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ git:\1/'
	# Uncomment this on UTF-8 compatible system.
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ ⎇  \1/'
}

# Helper function to set kubernetes context in shell prompt.
parse_k8s_context() {
    if [ -z "$KUBECONFIG" ]; then
        return
    fi

    local context namespace
    if [ -x "$(command -v yq)" ]; then
        context=$(yq e '.current-context // ""' "$KUBECONFIG")
        namespace=$(yq e "(.contexts[] | select(.name == \"$context\").context.namespace) // \"\"" "$KUBECONFIG")
    fi

    if [[ -n $context ]] && [[ -n $namespace ]]; then
        echo -n " (k8s:$context/$namespace)"
    elif [[ -n $context ]] ; then
        echo -n " (k8s:$context)"
    fi
}

# Some nice aliases to have
alias diff='diff --color'
alias git-cloc='git ls-files | xargs cloc'
alias sup='sudo -i'
alias ls='ls --color --group-directories-first'
alias ll='ls -lA'
# Some new age command replacement (like axa, zoxide, etc.)
#alias ls='exa'
#alias ll='exa -alh'
#alias tree='exa --tree'
# Kubernetes
alias k='kubectl'
alias kgp='kubectl get pods'
#alias kgj='kubectl get jobs'
#alias kga='kubectl get all'
#alias kgpv='kubectl get pvc'
#alias kgsv='kubectl get svc'
#alias kgl='kubectl logs'
complete -F __start_kubectl k
# Git
alias g='git'
# Speed-up start of Midnight Commander
alias mc='mc --nosubshell'
# Ansible 2.9 compatible with mitogen Project
# - Must be installed first (brew install ansible@2.9)
alias ansible-old='/opt/homebrew/opt/ansible@2.9/bin/ansible'

# Source another Aliases from external file (if exists).
if [ -f ~/.aliases ]; then
	. "$HOME"/.aliases
fi

# Select from multiple k8s clusters configurations.
kc() {
    local k8s_config
    k8s_config=$(find "$HOME"/.kube/ -type f -not -path "$HOME/.kube/old-config/*" \( -iname '*.yaml' -o -iname '*.yml' -o -iname '*.conf' -o -iname '*.kube' -o -iname 'config' \) | fzf)
    export KUBECONFIG="$k8s_config"
}

# alias for `kubectl exec`
kexec() {
    kubectl exec -it "$1" -- sh
}

gli () {
  git log --graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"  | \
   fzf --ansi --no-sort --reverse --tiebreak=index --preview \
   'f() { set -- $(echo -- "$@" | grep -o "[a-f0-9]\{7\}"); [ $# -eq 0 ] || git show --color=always $1 ; }; f {}' \
   --bind "q:abort,ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF" --preview-window=right:60%
}

# Node version manager
# Install:
# - Mac install via brew install nvm
mkdir -p ~/.nvm
export NVM_DIR="$HOME/.nvm"
# This loads nvm
[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
# This loads nvm bash_completion
[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"

# Generate npm completetion.
if [ -x "$(command -v npm)" ]; then
    # source <(npm completion)
    [ -s ~/.bash_completions/npm.sh ] || npm completion > ~/.bash_completions/npm.sh
fi

# Generate kubectl completetion.
if [ -x "$(command -v kubectl)" ]; then
    # source <(kubectl completion bash)
    [ -s ~/.bash_completions/kubectl.sh ] || kubectl completion bash > ~/.bash_completions/kubectl.sh
fi

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc or /etc/profile).
# If not sources particular file.
if ! shopt -oq posix; then
	# MacOS system with Homebrew.
    if [ -f "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]; then
        . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
    fi
    # Load local bash autocompletion files.
    if [ -d ~/.bash_completions ]; then
        for f in ~/.bash_completions/*.sh; do
            [[ -e "$f" ]] || break  # handle the case of no *.sh files
            . "$f"
        done
    fi
fi
