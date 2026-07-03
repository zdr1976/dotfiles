local opt = vim.opt

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
  set_hl(0, "GruvboxRed", { fg = "#ff5f5f" })
  set_hl(0, "GruvboxRedBold", { fg = "#ff7a7a", bold = true })
  set_hl(0, "SpellBad", { fg = "#fbf1c7", bg = "#ff5f5f", bold = true })
  set_hl(0, "SpellCap", { fg = "#fbf1c7", bg = "#458588" })
  set_hl(0, "SpellRare", { fg = "#fbf1c7", bg = "#b16286" })
  set_hl(0, "SpellLocal", { fg = "#fbf1c7", bg = "#689d6a" })
end

opt.laststatus = 2
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

apply_theme_overrides()

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = apply_theme_overrides,
})
