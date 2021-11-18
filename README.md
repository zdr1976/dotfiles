# dotfiles

Dotfiles are used to customize your system. The “dotfiles” name is derived
from the configuration files in Unix-like systems that start with a dot
(e.g. .bashrc and .gitconfig). For normal users, this indicates they are not
regular documents, and by default they are hidden in directory listings.
For power users, they are a core tool belt.

## Installation

To install configuration files use `stow` command. [GNU Stow](https://www.gnu.org/software/stow/manual/stow.html) is
a symlink farm manager.

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

### Stow dotfiles

You can `stow` all or selected configuration.

One
```console
stow -t ~ bash
```

Or multiple
```console
stow -t ~ bash vim zsh
```

Or all
```console
stow -t ~ *
```

To check what the `stow` command will do add `-n` and `-v` options.
