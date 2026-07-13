local M = {}

local function has(feature)
  return vim.fn.has(feature) == 1
end

M.is_nvim_010_or_newer = has("nvim-0.10")
M.is_nvim_011_or_newer = has("nvim-0.11")
M.has_completeopt_popup = M.is_nvim_010_or_newer
M.has_native_lsp_config = M.is_nvim_011_or_newer and vim.lsp and vim.lsp.config and type(vim.lsp.enable) == "function"

function M.joinpath(...)
  if vim.fs and vim.fs.joinpath then
    return vim.fs.joinpath(...)
  end

  return table.concat({ ... }, "/")
end

return M
