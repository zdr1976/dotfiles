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

function M.setup()
  local group = vim.api.nvim_create_augroup("dotfiles_format", { clear = true })

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
    callback = function(args)
      if not format_on_save_filetypes[vim.bo[args.buf].filetype] then
        return
      end

      local clients = vim.lsp.get_clients({ bufnr = args.buf })
      local has_formatter = vim.iter(clients):any(function(client)
        return client:supports_method("textDocument/formatting")
      end)

      if not has_formatter then
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
