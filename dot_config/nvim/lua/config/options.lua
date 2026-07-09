local opt = vim.opt

vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 0
vim.g.netrw_winsize = 25
vim.g.netrw_altv = 1
vim.g.netrw_chgwin = -1

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
  set_hl(0, "netrwDir", { fg = "#83a598", bold = true })
  set_hl(0, "netrwClassify", { fg = "#928374" })
  set_hl(0, "netrwSymLink", { fg = "#b8bb26" })
  set_hl(0, "netrwExe", { fg = "#fabd2f" })
end

local undodir = vim.fs.joinpath(vim.fn.stdpath("state"), "undo")
vim.fn.mkdir(undodir, "p")

opt.number = true
opt.swapfile = false
opt.splitright = true
opt.splitbelow = true
opt.showmode = false
opt.ignorecase = true
opt.smartcase = true
opt.completeopt = { "menu", "menuone", "popup" }
opt.pumheight = 10
opt.cursorline = true
opt.cursorlineopt = "number"
opt.foldenable = false
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.ttimeoutlen = 10
opt.updatetime = 100
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
opt.undodir = undodir

opt.formatoptions:remove("t")

apply_theme_overrides()

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = apply_theme_overrides,
})
