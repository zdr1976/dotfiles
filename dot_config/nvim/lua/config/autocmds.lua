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

    local set_hl = vim.api.nvim_set_hl

    set_hl(0, "GitCommitDiffAdd", { fg = "#98971a", bg = "NONE" })
    set_hl(0, "GitCommitDiffDelete", { fg = "#ff5f5f", bg = "NONE" })
    set_hl(0, "GitCommitDiffChange", { fg = "#d79921", bg = "NONE" })
    set_hl(0, "GitCommitDiffText", { fg = "#458588", bg = "NONE", bold = true })

    set_hl(0, "gitcommitSummary", { fg = "#ebdbb2", bold = true })
    set_hl(0, "gitcommitComment", { fg = "#928374", italic = true })
    set_hl(0, "gitcommitHeader", { fg = "#83a598" })
    set_hl(0, "gitcommitBranch", { fg = "#b8bb26", bold = true })

    local extra_winhighlight = table.concat({
      "DiffAdd:GitCommitDiffAdd",
      "DiffDelete:GitCommitDiffDelete",
      "DiffChange:GitCommitDiffChange",
      "DiffText:GitCommitDiffText",
    }, ",")

    local current_winhighlight = vim.api.nvim_get_option_value("winhighlight", { scope = "local" })
    if current_winhighlight == "" then
      vim.opt_local.winhighlight = extra_winhighlight
    else
      vim.opt_local.winhighlight = current_winhighlight .. "," .. extra_winhighlight
    end
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
