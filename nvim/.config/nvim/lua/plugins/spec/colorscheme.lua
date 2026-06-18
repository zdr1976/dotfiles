return {
  {
    "morhetz/gruvbox",
    priority = 1000,
    lazy = false,
    config = function()
      vim.g.gruvbox_italic = 1
      vim.cmd.colorscheme("gruvbox")
    end,
  },
}
