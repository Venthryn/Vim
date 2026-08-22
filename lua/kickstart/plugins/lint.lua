return {
  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
    keys = {
      -- Linting already runs automatically (see the autocmd below); this is
      -- just a manual trigger for forcing a re-lint on demand.
      {
        '<leader>l',
        function()
          require('lint').try_lint()
        end,
        desc = '[L]int Buffer',
      },
    },
    config = function()
      local lint = require('lint')
      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
        -- cppcheck is NOT in the Mason registry (mason-registry only has
        -- cpplint/cpptools, no cppcheck), so it's installed via flake.nix's
        -- home.packages instead of ensure_installed below.
        c = { 'cppcheck' },
        cpp = { 'cppcheck' },
        sh = { 'shellcheck' },
      }

      -- This is the one mason-tool-installer.setup() call in the config, so
      -- it also owns installing jdtls + its debug/test bundles for
      -- kickstart.plugins.jdtls (ftplugin/java.lua), and stylua/clang-format
      -- for kickstart.plugins.conform, not just linters. cppcheck excluded:
      -- see comment above.
      require('mason-tool-installer').setup({
        ensure_installed = { 'markdownlint', 'shellcheck', 'stylua', 'clang-format', 'jdtls', 'java-debug-adapter', 'java-test' },
      })

      local lint_augroup = vim.api.nvim_create_augroup('kickstart-lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          -- Only run the linter in buffers that you can modify in order to
          -- avoid superfluous noise, notably within the handy LSP pop-ups that
          -- describe the hovered symbol using Markdown.
          if vim.bo.modifiable then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
