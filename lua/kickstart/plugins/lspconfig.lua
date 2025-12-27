-- LSP Plugins
return {
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {

      { 'dundalek/lazy-lsp.nvim' },

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim',     opts = {} },

      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function()
      vim.diagnostic.config({
        virtual_text = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
          }
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if cmp_ok then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
      end

      vim.lsp.config("lua_ls", { capabilities = capabilities, on_attach = on_attach })
      vim.lsp.enable("lua_ls")

      vim.lsp.config("jdtls", { capabilities = capabilities, on_attach = on_attach })
      vim.lsp.enable("jdtls")
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
