local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local config_group = augroup("dotfiles_config", { clear = true })
local language_group = augroup("dotfiles_languages", { clear = true })

autocmd("BufWritePost", {
  group = config_group,
  pattern = { "init.lua", "*/lua/config/*.lua" },
  callback = function()
    dofile(vim.env.MYVIMRC)
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "gitcommit",
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.textwidth = 72
  end,
})

autocmd({ "BufRead", "BufNewFile" }, {
  group = language_group,
  pattern = "*/playbooks/*.yml",
  callback = function()
    vim.bo.filetype = "ansible"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = { "yaml", "json", "html", "javascript", "typescript", "sh", "bash" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

autocmd("InsertLeave", {
  group = language_group,
  callback = function()
    vim.opt.paste = false
  end,
})

autocmd("VimEnter", {
  group = config_group,
  callback = function()
    if vim.wo.diff then
      vim.opt_local.wrap = true
      vim.opt_local.linebreak = true
      vim.opt_local.showbreak = "↪"
      vim.opt_local.display:append("lastline")
    end
  end,
})
