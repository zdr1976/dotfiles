vim.g.mapleader = ","
vim.g.maplocalleader = ","

require("config.clipboard").setup()
require("config.options")
require("plugins")
require("config.keymaps")
require("config.autocmds")
