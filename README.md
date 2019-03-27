# dotfiles

Dotfiles are used to customize your system. The “dotfiles” name is derived
from the configuration files in Unix-like systems that start with a dot
(e.g. .bashrc and .gitconfig). For normal users, this indicates they are not
regular documents, and by default they are hidden in directory listings.
For power users, they are a core tool belt.

## Installation

If you are running MacOS please install brew package management before. Homebrew
is the missing package management for macOS. For more information about this
package management please visit the project [homepage](http://brew.sh/).

```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Some useful packages worth to install.
```bash
brew install bash bash-completion mc vim colordiff sipcalc ipcalc htop ssh-copy-id wget python python3 cloc golang cmake
```

Now we are ready to setup dotfiles locally.

```bash
git clone git@github.com:zdr1976/dotfiles.git
cd dotfiles
./install
```

## Postistall
In this section I will continue to document specifics postinstall steps.

### Python
We don't want to install all Python packages in to the global `PATH`. That can be convenient
at times, but it can also create problems. For example, sometimes one project needs the
latest version of `Django`, while another project needs an older `Django` version to retain
compatibility with a critical third-party extension. This is one of many use cases that
`virtualenv` was designed to solve. That's why we are installing only a handful of
general-purpose Python packages in to the global `PATH`. Every other package is confined
to virtual environments.
```bash
pip install virtualenv virtualenvwrapper
```

Then open your `.bashrc` or `.zshrc` file (which may be created but only
in case you are not using mine) and ad some lines to it. What those lines do is
restricting `pip` and `pip3` to install to virtual environments only.
To overcome this restriction and allow `pip` and `pip3`
to install package into the global PATH use `gpip/gpip3` command instead.
```bash
export PIP_REQUIRE_VIRTUALENV=true
export WORKON_HOME=~/.virtualenvs

# Temporarily turn off restriction for pip.
gpip(){
  PIP_REQUIRE_VIRTUALENV="" pip "$@"
}

gpip3(){
  PIP_REQUIRE_VIRTUALENV="" pip3 "$@"
}
```

Create some directories to store our projects and virtual environments, respectively:
```bash
mkdir -p ~/Projects ~/.virtualenvs
```

