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


```bash
git clone git@github.com:zdr1976/dotfiles.git
or
git clone https://github.com/zdr1976/dotfiles.git
cd dotfiles
git config user.email "you@example.com"
git config user.name "Your Name"
./install
vim -c VundleUpdate -c quitall
```

## Postistall
In this section I will continue to document specifics postinstall steps.

### Python
We don't want to install all Python packages in to the global PATH. That can be convenient
at times, but it can also create problems. For example, sometimes one project needs the
latest version of Django, while another project needs an older Django version to retain
compatibility with a critical third-party extension. This is one of many use cases that
**virtualenv** was designed to solve. That's why we are installing only a handful of
general-purpose Python packages (such as virtualenv) in to the global PATH. Every other
package is confined to virtual environments.

```bash
pip install virtualenv
```

Create some directories to store our projects and virtual environments, respectively:

```bash
mkdir -p ~/Projects ~/.virtualenvs
```

Then open your *bashrc* file (which may be created if it doesn’t exist yet) but only
if you are not using ours and ad some lines to it. What this do is to restricting pip
to install to virtual environments only. To overcome this restriction and allow *pip*
to install package into the global PATH use *gpip* command instead of *pip*.
```bash
export PIP_REQUIRE_VIRTUALENV=true
export WORKON_HOME=~/.virtualenvs

# Temporarily turn off restriction for pip.
gpip(){
  PIP_REQUIRE_VIRTUALENV="" pip "$@"
}
```
