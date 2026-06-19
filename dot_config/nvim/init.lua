vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("config.options")
require("plugins")
require("config.keymaps")
require("config.autocmds")
require("config.format").setup()
