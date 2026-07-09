local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local language_group = augroup("dotfiles_languages", { clear = true })
local ansible_paths = {
  "/playbooks/.+%.ya?ml$",
  "/roles/.+/tasks/.+%.ya?ml$",
  "/roles/.+/handlers/.+%.ya?ml$",
  "/roles/.+/vars/.+%.ya?ml$",
  "/roles/.+/defaults/.+%.ya?ml$",
}

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
  pattern = { "*.yml", "*.yaml" },
  callback = function(args)
    local path = args.file

    for _, pattern in ipairs(ansible_paths) do
      if path:match(pattern) then
        vim.bo[args.buf].filetype = "yaml.ansible"
        return
      end
    end

    local filename = vim.fn.fnamemodify(path, ":t")
    if filename == "docker-compose.yml"
      or filename == "docker-compose.yaml"
      or filename == "compose.yml"
      or filename == "compose.yaml"
    then
      vim.bo[args.buf].filetype = "yaml.docker-compose"
    end
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = {
    "bash",
    "hcl",
    "html",
    "javascript",
    "json",
    "sh",
    "terraform",
    "toml",
    "typescript",
    "yaml",
    "yaml.ansible",
    "yaml.docker-compose",
  },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})
