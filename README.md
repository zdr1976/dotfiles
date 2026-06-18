# dotfiles

Dotfiles are used to customize your system. The “dotfiles” name is derived
from the configuration files in Unix-like systems that start with a dot
(e.g. .bashrc and .gitconfig). For normal users, this indicates they are not
regular documents, and by default they are hidden in directory listings.
For power users, they are a core tool belt.

## Installation

To install configuration files, use [`stow`](https://www.gnu.org/software/stow/manual/stow.html).
GNU Stow is a symlink farm manager and works well for this repository
layout.

### MacOS

If you are running `MacOS` please install brew package management before. Homebrew
is the missing package management for `MacOS`. For more information about this
package management and how to install it please visit the project [homepage](http://brew.sh/).

So the first step after `brew` installation is `stow` installation.

```console
brew install stow
```

### Linux

If you are using `Linux` use your distribution package manager to install `stow`
application.

Debian base distributions can use `apt`.
```console
apt-get install stow
```

For `RedHat` base distribution use `yum` or `dnf`.
```console
dnf install stow
```

### Package list

The main packages in this repository are:

- `bash`
- `git`
- `nvim`
- `starship`
- `tmux`
- `vim`

### Install

Install one package:

```console
stow -t ~ bash
```

Install multiple packages:

```console
stow -t ~ bash git nvim starship tmux vim
```

### Preview changes

Preview what `stow` would do without changing anything:

```console
stow -n -v -t ~ bash git nvim starship tmux vim
```

### Update

Usually updating means:

1. Pull the latest changes in the repository.
2. Re-run `stow` for the packages you use.

```console
git pull
stow -R -t ~ bash git nvim starship tmux vim
```

The `-R` flag restows the package, which is useful after files move or
change inside the package directory.

### Remove

Remove one package:

```console
stow -D -t ~ bash
```

Remove multiple packages:

```console
stow -D -t ~ bash git nvim starship tmux vim
```

## Git Config Templates

This repository keeps Git config as templates so you can generate the
tracked files with your own name and email address.

Generated files live inside the `git/` package:

- `git/.gitconfig`
- `git/.gitconfig-personal`
- `git/.gitconfig-work`

Use `./generate-gitconfig.sh` to create the files, then install the
`git` package with `stow`.

### Personal account only

Use `gitconfig.tmpl` when you use one Git identity everywhere.

Interactive:

```console
./generate-gitconfig.sh single
```

Non-interactive:

```console
./generate-gitconfig.sh single "Your Name" "you@example.com"
```

Then stow it:

```console
stow -t ~ git
```

### Personal and work accounts

Use this setup when you want one shared `.gitconfig` plus separate
personal and work identities.

Interactive:

```console
./generate-gitconfig.sh multi
```

Non-interactive:

```console
./generate-gitconfig.sh multi \
  "Personal Name" "personal@example.com" \
  "Work Name" "work@example.com"
```

Then stow it:

```console
stow -t ~ git
```
