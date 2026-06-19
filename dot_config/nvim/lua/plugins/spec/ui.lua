return {
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      view = {
        width = 35,
      },
      renderer = {
        group_empty = true,
        icons = {
          show = {
            file = false,
            folder = false,
            folder_arrow = false,
            git = false,
          },
        },
      },
      filters = {
        dotfiles = false,
      },
      update_focused_file = {
        enable = true,
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        icons_enabled = false,
        theme = "gruvbox",
        section_separators = "",
        component_separators = { left = "|", right = "|" },
        globalstatus = false,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "diagnostics", "filetype", "fileformat", "encoding" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {
        lualine_a = { "tabs" },
        lualine_z = { "buffers" },
      },
    },
  },
}
