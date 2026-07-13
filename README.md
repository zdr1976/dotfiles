# dotfiles

This repository manages personal dotfiles with [chezmoi](https://www.chezmoi.io/).

The repository is the source of truth. Files are edited directly in git and then
applied to the home directory with `chezmoi`. Unlike the previous GNU Stow
setup, chezmoi renders and copies the final files into place instead of
symlinking them.

## Layout

This repository follows a chezmoi-style layout:

- `dot_bash_profile` -> `~/.bash_profile`
- `dot_bashrc` -> `~/.bashrc`
- `dot_tmux.conf.tmpl` -> `~/.tmux.conf`
- `dot_config/git/` -> `~/.config/git/`
- `dot_config/nvim/` -> `~/.config/nvim/`
- `dot_config/starship.toml` -> `~/.config/starship.toml`
- `dot_config/tmux/` -> `~/.config/tmux/`

The real Git identity values are not committed. Use a local
`.chezmoidata.yaml` file based on `.chezmoidata.example.yaml`.

## Prerequisites

Install `chezmoi` first.

### macOS

```console
brew install chezmoi
```

### Linux

Use your distribution package manager.

Debian and Ubuntu:

```console
apt-get install chezmoi
```

Fedora and RHEL:

```console
dnf install chezmoi
```

## Git Identity Data

This repository tracks `.chezmoidata.example.yaml` as a template and ignores the
real `.chezmoidata.yaml`.

Create your local data file:

```console
cp .chezmoidata.example.yaml .chezmoidata.yaml
```

Then edit `.chezmoidata.yaml` with your real values.

Example:

```yaml
git:
  defaultIdentity: personal
  personal:
    name: "Your Name"
    email: "personal@example.com"
  # Optional second profile.
  work:
    name: "Your Name"
    email: "work@example.com"
```

`defaultIdentity` controls which identity is used by default on the machine.

- `work`: use work everywhere except personal repos
- `personal`: use personal everywhere except work repos

The `personal` profile is the minimum required setup. The `work` profile is
optional.

## Clean System Setup

On a new machine, clone the repository first:

```console
git clone <repo-url> ~/Projects/Personal/dotfiles
cd ~/Projects/Personal/dotfiles
```

Create your local data file from the example and populate it with your real
values:

```console
cp .chezmoidata.example.yaml .chezmoidata.yaml
```

If you are working directly from this cloned repository with `chezmoi --source`,
keeping `.chezmoidata.yaml` in the repository root is enough:

```console
chezmoi --source "$PWD" diff
chezmoi --source "$PWD" apply
```

## Daily Workflow

Edit files in this repository directly with your normal editor.

Preview what chezmoi would change:

```console
chezmoi --source "$PWD" diff
```

Apply the changes to your home directory:

```console
chezmoi --source "$PWD" apply
```

You can also inspect rendered output without applying everything:

```console
chezmoi --source "$PWD" cat ~/.config/git/config
```

## First-Time Apply

From the repository root:

```console
chezmoi --source "$PWD" apply
```

This writes the managed files into your home directory.

## Git Config

Git config is managed under `dot_config/git/` and is rendered to:

- `~/.config/git/config`
- `~/.config/git/config-base`
- `~/.config/git/config-personal`
- `~/.config/git/config-work`

The main config uses includes and `includeIf` rules for personal and work
repositories.

By default, repository paths under `~/Projects/Personal/` use the personal
identity and paths under `~/Projects/Work/` use the work identity.

If you do not use that directory layout, the path-based override will not
trigger. In that case, Git will keep using the default identity from
`.chezmoidata.yaml`.

If you want work repos in a different location, update the `includeIf`
patterns in [config.tmpl](/Users/rastislav.slavicek/Projects/Personal/dotfiles/dot_config/git/config.tmpl).

## Tmux

Tmux keeps `~/.tmux.conf` as the main entrypoint, while support files live
under:

- `~/.config/tmux/tmux.adapta.conf`
- `~/.config/tmux/tmux.gruvbox.conf`
- `~/.config/tmux/tmux_cheatsheet.md`

## Neovim

Neovim is managed under:

- `~/.config/nvim/init.lua`
- `~/.config/nvim/lua/...`

If you decide to track `lazy-lock.json`, keep it under `dot_config/nvim/`.

## Notes

- This repository is edited as a normal git project; `chezmoi edit` is not
  required.
- The real `.chezmoidata.yaml` is intentionally ignored and should stay local.
- Generated target files in `~` are not part of this repository.
