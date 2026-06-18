local opt = vim.opt

vim.g.gruvbox_italic = 1

local function apply_theme_overrides()
  local set_hl = vim.api.nvim_set_hl

  set_hl(0, "NormalFloat", { fg = "#ebdbb2", bg = "#3c3836" })
  set_hl(0, "FloatBorder", { fg = "#665c54", bg = "#3c3836" })
  set_hl(0, "FloatTitle", { fg = "#83a598", bg = "#3c3836", bold = true })
  set_hl(0, "CursorLineNr", { fg = "#fabd2f", bold = true })
  set_hl(0, "Pmenu", { fg = "#ebdbb2", bg = "#282828" })
  set_hl(0, "PmenuSel", { fg = "#282828", bg = "#83a598", bold = true })
  set_hl(0, "PmenuSbar", { bg = "#3c3836" })
  set_hl(0, "PmenuThumb", { bg = "#665c54" })
end

opt.laststatus = 2
opt.encoding = "utf-8"
opt.autoindent = true
opt.incsearch = true
opt.hlsearch = true
opt.errorbells = false
opt.number = true
opt.swapfile = false
opt.backup = false
opt.splitright = true
opt.splitbelow = true
opt.showmode = false
opt.ignorecase = true
opt.smartcase = true
opt.completeopt = { "menu", "menuone", "popup" }
opt.pumheight = 10
opt.cursorcolumn = false
opt.cursorline = true
opt.cursorlineopt = "number"
opt.undolevels = 1000
opt.undoreload = 1000
opt.history = 1000
opt.foldenable = false
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.ttimeoutlen = 10
opt.timeoutlen = 1000
opt.updatetime = 100
opt.background = "dark"
opt.termguicolors = true
opt.colorcolumn = "80"
opt.listchars = {
  tab = "»·",
  nbsp = "+",
  trail = "·",
  extends = "→",
  precedes = "←",
}
opt.showbreak = "↳"
opt.clipboard:append({ "unnamed", "unnamedplus" })
opt.undofile = true
opt.undodir = vim.fn.expand("~/.config/nvim/undo")

opt.formatoptions:remove("t")

vim.cmd("syntax enable")
vim.cmd.colorscheme("default")
apply_theme_overrides()

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = apply_theme_overrides,
})

vim.cmd([[
  highlight clear SpellBad
  highlight SpellBad cterm=underline ctermbg=66 ctermfg=235
  highlight clear SpellRare
  highlight SpellRare cterm=underline ctermbg=66 ctermfg=235
  highlight clear SpellCap
  highlight SpellCap cterm=underline ctermbg=66 ctermfg=235
  highlight clear SpellLocal
  highlight SpellLocal cterm=underline ctermbg=66 ctermfg=235
]])
