-- LSP Plugins
return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = { library = { { path = '${3rd}/luv/library', words = { 'vim%.uv' } } } },
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'saghen/blink.cmp',
    },
    config = function()
      vim.diagnostic.config({
        virtual_text = true,
        signs = { text = {
          [vim.diagnostic.severity.ERROR] = '',
          [vim.diagnostic.severity.WARN] = '',
          [vim.diagnostic.severity.INFO] = '',
          [vim.diagnostic.severity.HINT] = '',
        } },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- Neovim 0.11+ already ships default global LSP keymaps (gra, gri,
      -- grn, grr, grt, grx, gO, <C-s> insert-mode signature help, buffer-
      -- local K for hover). We only add what core doesn't provide (grD,
      -- gW), and upgrade the "list" ones to Telescope pickers.
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            vim.keymap.set(mode or 'n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Merge blink.cmp's enhanced capabilities into every LSP config via
      -- the '*' base config. Replaces the old cmp_nvim_lsp check, which was
      -- always failing (this repo uses blink.cmp, not nvim-cmp).
      vim.lsp.config('*', {
        capabilities = require('blink.cmp').get_lsp_capabilities(),
      })

      -- Declarative server table: single source of truth for which
      -- language servers are installed (via mason) and how each is
      -- configured (via vim.lsp.config/vim.lsp.enable).
      local servers = {
        lua_ls = {
          settings = {
            Lua = { completion = { callSnippet = 'Replace' } },
          },
        },
        clangd = {
          -- --background-index made explicit (clangd's own recommended
          -- default, self-documenting). --pch-storage=memory trades RAM for
          -- meaningfully faster parsing/completion against a codebase
          -- Unreal Engine's size. Project-specific tuning (CompileFlags,
          -- Index.Background skip lists, etc.) belongs in a .clangd file at
          -- the UE project root instead — see templates/unreal.clangd.yaml.
          cmd = { 'clangd', '--clang-tidy', '--background-index', '--pch-storage=memory' },
        },
        bashls = {},
      }

      require('mason-lspconfig').setup({
        -- clangd is deliberately excluded from Mason-managed installs: the
        -- Unreal Engine integration (kickstart.plugins.unreal) depends on a
        -- system/toolchain-matched clangd + compile_commands.json. Letting
        -- Mason install its own clangd risks a version/ABI mismatch.
        -- clangd stays system-installed but is still declared/enabled below.
        --
        -- jdtls is deliberately excluded too: Java is handled entirely by
        -- kickstart.plugins.jdtls + ftplugin/java.lua (nvim-jdtls), which
        -- needs per-project workspace state this generic loop can't give
        -- it. Its binary is installed via kickstart.plugins.lint's
        -- mason-tool-installer list instead.
        ensure_installed = { 'lua_ls', 'bashls' },
        automatic_enable = false, -- we call vim.lsp.enable() ourselves below
      })

      for server_name, server_opts in pairs(servers) do
        vim.lsp.config(server_name, server_opts)
        vim.lsp.enable(server_name)
      end
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
