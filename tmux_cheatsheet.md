# tmux tips

Default prefix: `<ctrl>b`

## Session management

* `tmux new -s session_name` - creates a new tmux session named `session_name`
* `tmux a` - attach to first available session
* `tmux attach -t session_name` - attaches to an existing tmux session named `session_name`
* `tmux switch -t session_name` - switches to an existing session named `session_name`
* `tmux ls, <prefix>,s - lists existing tmux sessions
* `tmux detach, <prefix>,d` - detach the currently attached session
* `tmux kill-session -t session-name`
* `<prefix>,$` - rename session

## Windows

* `<prefix>,c` - create a new window
* `<prefix>,n` - next window
* `<prefix>,p` - prev window
* `<prefix>,0-9` - move to the window based on index
* `<prefix>,,` - rename the current window
* `<prefix>,w` - list windows
* `<prefix>,"` - splits into two vertical panes
* `<prefix>,%` - splits into two horizontal panes

## Panes

* `<prefix>,{` or `}` - swaps pane with another in the specified direction
* `<prefix>,{up,down,left,right}` - selects the next pane in the specified direction
* `<prefix>,q` - show pane numbers
* `<prefix>,o` - toggle between panes
* `<prefix>,}` - swap with next pane
* `<prefix>,{` - swap with previous pane
* `<prefix>,z` - toggle maximising current pane
* `<prefix>,!` - break the pane out of the window
* `<prefix>,x` - kill the current pane
* `tmux select-pane -t :.+` - selects the next pane in numerical order
* `<prefix>,t` - show the time in current pane
* `<prefix>,<ctrl>{left,right,up,down}` - resize pane
* `<prefix>,space` - swap between default layouts (e.g. switch from vertical split to horizontal)

## Other

* `tmux list-keys` - lists out every bound key and the tmux command it runs
* `tmux list-commands` - lists out every tmux command and its arguments
* `tmux info` - lists out every session, window, pane, its pid, etc.
* `tmux source-file ~/.tmux.conf` - reload config file
* `<prefix>,q` - exit scroll mode
* `<prefix>,PgUp` - scroll up
 
## Copy and paste

1. `<prefix>,[` - enter scroll/copy mode
1. `space` - start copying from cursor position
1. `enter` - stop copying from cursor position
1. `<prefix>,]` - paste
