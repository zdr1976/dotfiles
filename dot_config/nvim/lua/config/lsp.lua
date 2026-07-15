local M = {}
local compat = require("config.compat")

function M.setup()
  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  local servers = {
    ansiblels = {},
    bashls = {},
    cssls = {},
    dockerls = {},
    gopls = {},
    html = {},
    jsonls = {},
    lua_ls = {
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = {
            enable = false,
          },
        },
      },
    },
    pyright = {},
    taplo = {},
    terraformls = {},
    ts_ls = {},
    yamlls = {
      settings = {
        yaml = {
          validate = true,
          completion = true,
          hover = true,
          schemaStore = {
            enable = false,
            url = "",
          },
          schemas = {
            ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/main/service-schema.json"] = {
              "azure-pipelines.yml",
              "azure-pipelines.yaml",
              "azure-pipelines-*.yml",
              "azure-pipelines-*.yaml",
            },
          },
        },
      },
    },
  }

  for server, config in pairs(servers) do
    config.capabilities = capabilities
    if compat.has_native_lsp_config then
      vim.lsp.config(server, config)
    else
      require("lspconfig")[server].setup(config)
    end
  end

  if compat.has_native_lsp_config then
    vim.lsp.enable(vim.tbl_keys(servers))
  end

  local group = vim.api.nvim_create_augroup("dotfiles_lsp", { clear = true })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(event)
      local map = function(keys, func, desc, mode)
        vim.keymap.set(mode or "n", keys, func, {
          buffer = event.buf,
          desc = desc,
        })
      end

      map("gd", vim.lsp.buf.definition, "Go to definition")
      map("gy", vim.lsp.buf.type_definition, "Go to type definition")
      map("gi", vim.lsp.buf.implementation, "Go to implementation")
      map("gr", vim.lsp.buf.references, "Go to references")
      map("K", function()
        vim.lsp.buf.hover({
          border = "single",
        })
      end, "Hover documentation")
      map("<Leader>rn", vim.lsp.buf.rename, "Rename symbol")
      map("<Leader>a", vim.lsp.buf.code_action, "Code action", { "n", "x" })
      map("<Leader>f", function()
        vim.lsp.buf.format({ async = true })
      end, "Format buffer")
    end,
  })

  vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
      border = "rounded",
    },
  })
end

return M
