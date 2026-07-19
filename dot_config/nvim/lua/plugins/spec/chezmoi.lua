return {
  "xvzc/chezmoi.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  -- Load this plugin automatically when you open a file inside your chezmoi source path
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("chezmoi").setup({
      edit = {
        watch = true,
        force = false,
      },
      notification = {
        on_open = true,
        on_apply = true,
      },
    })
  end,
}
