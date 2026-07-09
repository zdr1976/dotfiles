local M = {}

function M.setup()
  require("harpoon").setup({
    global_settings = {
      save_on_toggle = true,
      save_on_change = true,
    },
  })
end

function M.add_file()
  require("harpoon.mark").add_file()
end

function M.toggle_menu()
  require("harpoon.ui").toggle_quick_menu()
end

function M.prev()
  require("harpoon.ui").nav_prev()
end

function M.next()
  require("harpoon.ui").nav_next()
end

return M
