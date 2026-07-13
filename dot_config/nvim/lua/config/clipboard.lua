local M = {}

function M.setup()
  if vim.fn.has("mac") == 1 then
    return
  end

  if vim.fn.executable("wl-copy") == 1 and vim.fn.executable("wl-paste") == 1 then
    vim.g.clipboard = {
      name = "wl-clipboard",
      copy = {
        ["+"] = "wl-copy",
        ["*"] = "wl-copy --primary",
      },
      paste = {
        ["+"] = "wl-paste --no-newline",
        ["*"] = "wl-paste --no-newline --primary",
      },
      cache_enabled = 0,
    }
    return
  end

  if vim.fn.executable("xclip") == 1 then
    vim.g.clipboard = {
      name = "xclip",
      copy = {
        ["+"] = "xclip -silent -in -selection clipboard",
        ["*"] = "xclip -silent -in -selection primary",
      },
      paste = {
        ["+"] = "xclip -out -selection clipboard",
        ["*"] = "xclip -out -selection primary",
      },
      cache_enabled = 0,
    }
    return
  end

  if vim.fn.executable("xsel") == 1 then
    vim.g.clipboard = {
      name = "xsel",
      copy = {
        ["+"] = "xsel --clipboard --input",
        ["*"] = "xsel --primary --input",
      },
      paste = {
        ["+"] = "xsel --clipboard --output",
        ["*"] = "xsel --primary --output",
      },
      cache_enabled = 0,
    }
  end
end

return M
