local parsers = {
  "bash",
  "diff",
  "dockerfile",
  "go",
  "gomod",
  "gosum",
  "hcl",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "terraform",
  "toml",
  "vim",
  "vimdoc",
  "yaml",
}

local filetypes = {
  "bash",
  "diff",
  "dockerfile",
  "go",
  "gomod",
  "gosum",
  "hcl",
  "json",
  "lua",
  "markdown",
  "python",
  "query",
  "terraform",
  "toml",
  "vim",
  "yaml",
  "yaml.ansible",
  "yaml.docker-compose",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = function()
      local treesitter = require("nvim-treesitter")
      treesitter.install(parsers, { summary = true }):wait(300000)
      treesitter.update(parsers, { summary = true }):wait(300000)
    end,
    config = function()
      local group = vim.api.nvim_create_augroup("dotfiles_treesitter", { clear = true })

      vim.treesitter.language.register("yaml", { "yaml.ansible", "yaml.docker-compose" })

      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = filetypes,
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },
}
