# Neovim Config

This directory contains the Lua-based Neovim configuration that lives
next to the legacy Vim configuration.

The goal of this setup is:

- keep the old `vim/.vim/vimrc` working for servers and plain Vim
- build a cleaner, more modular Neovim config in Lua
- keep shortcuts familiar where it makes sense

## Layout

```text
nvim/
  README.md
  .config/nvim/
    init.lua
    lazy-lock.json
    lua/
      config/
        autocmds.lua
        completion.lua
        gitsigns.lua
        keymaps.lua
        lsp.lua
        options.lua
        telescope.lua
      plugins/
        init.lua
        spec/
          colorscheme.lua
          git.lua
          lsp.lua
          search.lua
          ui.lua
```

## Start This Config

From the repository root:

```bash
XDG_CONFIG_HOME="$PWD/nvim/.config" nvim
```

On first start or after plugin changes:

```vim
:Lazy sync
```

Useful health checks:

```vim
:checkhealth
:checkhealth telescope
:checkhealth mason
:LspInfo
:Mason
:Lazy
```

## How It Is Organized

### `init.lua`

Entry point. Sets the leader key, disables `netrw` for `nvim-tree`, and
loads the config and plugin modules.

### `lua/config/options.lua`

Core editor options:

- numbers
- splits
- search behavior
- undo history
- clipboard
- colors
- popup and floating window highlights

### `lua/config/keymaps.lua`

Global keymaps that are not tied to a single plugin buffer.

### `lua/config/autocmds.lua`

Autocommands and augroups:

- git commit settings
- ansible filetype detection
- 2-space indentation for selected filetypes
- auto-reset paste mode
- diff view wrapping
- auto-reload for config files

### `lua/config/lsp.lua`

Native Neovim LSP setup:

- configures servers
- enables them with `vim.lsp.enable()`
- defines LSP buffer-local mappings
- sets diagnostic display behavior

### `lua/config/completion.lua`

Completion setup using `nvim-cmp` and `LuaSnip`.

### `lua/config/telescope.lua`

Telescope setup and helper for project-aware file finding.

### `lua/config/gitsigns.lua`

Git gutter signs and hunk actions.

### `lua/plugins/spec/*.lua`

Lazy plugin specs grouped by topic:

- `colorscheme.lua`
- `ui.lua`
- `search.lua`
- `lsp.lua`
- `git.lua`

## Plugins

### Theme

- `morhetz/gruvbox`
  The main colorscheme.

### UI

- `nvim-tree/nvim-tree.lua`
  File explorer replacement for NERDTree.
- `nvim-lualine/lualine.nvim`
  Statusline and tabline replacement for vim-airline.

### Search

- `nvim-telescope/telescope.nvim`
  Fuzzy file picker and text search.
- `nvim-lua/plenary.nvim`
  Utility dependency used by Telescope.

### Native LSP and Completion

- `mason-org/mason.nvim`
  Installs external editor tools like LSP servers.
- `mason-org/mason-lspconfig.nvim`
  Bridges Mason and Neovim LSP server names.
- `neovim/nvim-lspconfig`
  Server-specific LSP configuration data.
- `hrsh7th/nvim-cmp`
  Completion menu engine.
- `hrsh7th/cmp-nvim-lsp`
  LSP completion source for `nvim-cmp`.
- `hrsh7th/cmp-buffer`
  Buffer word completion source.
- `hrsh7th/cmp-path`
  Filesystem path completion source.
- `L3MON4D3/LuaSnip`
  Snippet engine.
- `saadparwaiz1/cmp_luasnip`
  Snippet completion source for `nvim-cmp`.

### Git

- `lewis6991/gitsigns.nvim`
  Git signs in the gutter and hunk actions.

## Installed / Expected LSP Servers

The current config asks Mason to install:

- `bashls`
- `cssls`
- `gopls`
- `html`
- `jsonls`
- `lua_ls`
- `pyright`
- `ts_ls`
- `yamlls`

## Main Shortcuts

Leader key:

- `,`

### Basic Toggles

- `<F3>` toggle line numbers
- `<F4>` toggle invisible characters
- `<F5>` toggle file explorer
- `<F12>` toggle spell checking
- `<C-n>` clear search highlighting

### Clipboard

- `<Leader>y` yank to `*` clipboard
- `<Leader>Y` yank to `+` clipboard
- `<Leader>p` paste from `*` clipboard
- `<Leader>P` paste from `+` clipboard

### Windows

- `<C-h>` `<C-j>` `<C-k>` `<C-l>` move between windows
- `<C-Left>` `<C-Down>` `<C-Up>` `<C-Right>` move between windows
- `+` increase split height
- `-` decrease split height
- `<Leader>+` increase split width
- `<Leader>-` decrease split width

### Tabs

- `<Leader>n` previous tab
- `<Leader>m` next tab
- `<Leader>1` ... `<Leader>9` jump to tab number
- `<Leader>0` last tab

### Search

- `<C-p>` project files
  Uses Git-aware file search when inside a Git repo and falls back to
  normal file search otherwise.
- `<C-g>` live grep


### Editing

- `v <` keep selection and indent left
- `v >` keep selection and indent right
- `<Leader>w` strip trailing whitespace in the current buffer

## LSP Shortcuts

These become available when an LSP server attaches to the current buffer.

- `gd` go to definition
- `gy` go to type definition
- `gi` go to implementation
- `gr` go to references
- `K` hover documentation
- `<Leader>rn` rename symbol
- `<Leader>a` code action
- `<Leader>f` format buffer

## Completion Shortcuts

- `<C-Space>` trigger completion
- `<CR>` confirm selected completion item
- `<C-e>` abort completion
- `<C-b>` scroll docs up
- `<C-f>` scroll docs down
- `<Tab>` next completion item or snippet jump
- `<S-Tab>` previous completion item or snippet jump back

## Git Shortcuts

These are active in Git-tracked buffers when `gitsigns` is attached.

- `]c` next hunk
- `[c` previous hunk
- `<Leader>hs` stage hunk
- `<Leader>hr` reset hunk
- visual `<Leader>hs` stage selected hunk
- visual `<Leader>hr` reset selected hunk
- `<Leader>hp` preview hunk
- `<Leader>hb` blame current line
- `<Leader>hd` diff current buffer
- `ih` select Git hunk text object

## Notes

- Icons are intentionally disabled in the UI because this setup should
  work well without patched Nerd Fonts.
- Floating windows are styled to fit the gruvbox palette.
- `lazy-lock.json` records the exact plugin versions currently in use.
- This config is still evolving. The Vim config remains the fallback for
  remote servers and plain Vim usage.
