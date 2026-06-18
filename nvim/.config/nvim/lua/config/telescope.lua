local M = {}

function M.setup()
  require("telescope").setup({
    defaults = {
      prompt_prefix = "> ",
      selection_caret = "> ",
      sorting_strategy = "ascending",
      layout_config = {
        prompt_position = "top",
      },
      mappings = {
        i = {
          ["<Esc>"] = require("telescope.actions").close,
        },
      },
    },
  })
end

function M.find_project_files()
  local builtin = require("telescope.builtin")

  local ok = pcall(builtin.git_files, { show_untracked = true })
  if not ok then
    builtin.find_files()
  end
end

return M
