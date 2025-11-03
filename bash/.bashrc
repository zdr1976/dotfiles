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
export PATH="$BREW_PREFIX/opt/openjdk/bin:$PATH"

# Some application store configuration in ~/.config directory.
mkdir -p ~/.config
# Create local bash completion directory if not already exists. This is used for kubernetes and npm completion files here.
mkdir -p ~/.bash_completions

# Set locales
export LANG=en_US.UTF-8
# Set location related locales
export LC_TIME=en_GB.UTF-8        # Date and time format
export LC_MONETARY=sk_SK.UTF-8    # Currency format
export LC_NUMERIC=sk_SK.UTF-8     # Numbers (decimal separator, grouping)
# Make sure LC_ALL is not set to override
unset LC_ALL

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
alias mc='mc -uX' # Disable X and subshell to start quick on Mac
# kubernetes
alias k='kubectl'
complete -F __start_kubectl k

# Source another Aliases from external file (if exists).
if [ -f ~/.aliases ]; then
    . "$HOME"/.aliases
fi

# Select from multiple k8s clusters configurations.
kc() {
    local k8s_config

    # Build list of kubeconfig files + add special "[default]" option
    k8s_config=$(
        {
            echo "[default]";
            find "$HOME"/.kube -type f -not -path "$HOME/.kube/old-config/*" \
                \( -iname '*.yaml' -o -iname '*.yml' -o -iname '*.conf' -o -iname '*.config' -o -iname '*.kube' \);
        } | fzf --prompt="Select kubeconfig > " --height=20% --border
    )

    # Handle user selection
    if [[ -z "$k8s_config" ]]; then
        echo "No selection. KUBECONFIG unchanged."
        return 1
    elif [[ "$k8s_config" == "[default]" ]]; then
        unset KUBECONFIG
        echo "KUBECONFIG unset (using default ~/.kube/config)."
    else
        export KUBECONFIG="$k8s_config"
        echo "KUBECONFIG set to: $k8s_config"
    fi
}


gli () {
    git log --graph --color=always --format="%C(red)%h%C(reset) %C(yellow)%d%C(reset) %s %C(green)(%cr) %C(bold blue)<%an>%C(reset)"  | \
        fzf --ansi --no-sort --reverse --tiebreak=index --preview \
        'f() { set -- $(echo -- "$@" | grep -o "[a-f0-9]\{7\}"); [ $# -eq 0 ] || git show --color=always $1 ; }; f {}' \
        --bind "q:abort,ctrl-m:execute:
            (grep -o '[a-f0-9]\{7\}' | head -1 |
            xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
            {}
FZF-EOF" --preview-window=right:50%
}

awsp() {
    AWS_PROFILE="$(aws configure list-profiles | fzf)"
    export AWS_PROFILE
    echo "Switched to AWS profile '$AWS_PROFILE'."
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

# If Go lang is installed add GOPATH in to to PATH variable
if [ -x "$(command -v go)" ]; then
    gopath=$(go env GOPATH)
    export PATH=${gopath}/bin:$PATH
fi

# Python pyenv setup
export PYENV_ROOT="$HOME/.pyenv"
export PATH="${PYENV_ROOT}/bin:$PATH"

if command -v pyenv >/dev/null 2>&1; then
    eval "$(pyenv init -)"
    # eval "$(pyenv virtualenv-init -)"
fi

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc or /etc/profile).
# If not sources particular file.
if ! shopt -oq posix; then
	# MacOS system with Homebrew.
    if [ -f "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]; then
        LANG=C source "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
    fi
    # Load local bash autocompletion files.
    if [ -d ~/.bash_completions ]; then
        for f in ~/.bash_completions/*.sh; do
            [[ -e "$f" ]] || break  # handle the case of no *.sh files
            . "$f"
        done
    fi
fi
