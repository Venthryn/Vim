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
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function()
      require("lazy-lsp").setup {
        default_config = {
          flags = { debounce_text_changes = 150 },
        },
        servers = {
          "java-language-server",
        },
      }

      local lspconfig = require("lspconfig")
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local on_attach = function(client, bufnr)
        -- Add keybinds here
      end
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
