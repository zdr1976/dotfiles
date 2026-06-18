local M = {}

function M.setup()
  require("gitsigns").setup({
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
    signcolumn = true,
    numhl = false,
    linehl = false,
    word_diff = false,
    current_line_blame = false,
    on_attach = function(bufnr)
      local gitsigns = require("gitsigns")

      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, {
          buffer = bufnr,
          desc = desc,
        })
      end

      map("n", "]c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gitsigns.nav_hunk("next")
        end
      end, "Next git hunk")

      map("n", "[c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gitsigns.nav_hunk("prev")
        end
      end, "Previous git hunk")

      map("n", "<leader>hs", gitsigns.stage_hunk, "Stage hunk")
      map("n", "<leader>hr", gitsigns.reset_hunk, "Reset hunk")
      map("v", "<leader>hs", function()
        gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Stage selected hunk")
      map("v", "<leader>hr", function()
        gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Reset selected hunk")
      map("n", "<leader>hp", gitsigns.preview_hunk, "Preview hunk")
      map("n", "<leader>hb", function()
        gitsigns.blame_line({ full = true })
      end, "Blame line")
      map("n", "<leader>hd", gitsigns.diffthis, "Diff buffer")
      map({ "o", "x" }, "ih", gitsigns.select_hunk, "Select hunk")
    end,
  })
end

return M
