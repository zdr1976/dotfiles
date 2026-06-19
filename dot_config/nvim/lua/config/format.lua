local M = {}

local format_on_save_filetypes = {
  bash = true,
  css = true,
  go = true,
  html = true,
  javascript = true,
  json = true,
  lua = true,
  python = true,
  typescript = true,
  yaml = true,
}

local function should_format(bufnr)
  return format_on_save_filetypes[vim.bo[bufnr].filetype]
end

local function has_formatter(bufnr)
  return vim.iter(vim.lsp.get_clients({ bufnr = bufnr })):any(function(client)
    return client:supports_method("textDocument/formatting")
  end)
end

function M.setup()
  local group = vim.api.nvim_create_augroup("dotfiles_format", { clear = true })

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
    callback = function(args)
      if not should_format(args.buf) then
        return
      end

      if not has_formatter(args.buf) then
        return
      end

      vim.lsp.buf.format({
        bufnr = args.buf,
        async = false,
      })
    end,
  })
end

return M
