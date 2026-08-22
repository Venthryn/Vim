-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- Plugins are modular: `require 'kickstart.plugins.<name>'` loads the spec
-- from lua/kickstart/plugins/<name>.lua. Grouped below by concern.
require('lazy').setup({
  'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically

  -- AI / Completion
  require 'kickstart.plugins.supermaven',
  require 'kickstart.plugins.blink-cmp',

  -- LSP & tooling
  require 'kickstart.plugins.lspconfig',
  require 'kickstart.plugins.jdtls',
  require 'kickstart.plugins.conform',
  require 'kickstart.plugins.lint',

  -- Editing
  require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.gitsigns',
  require 'kickstart.plugins.which-key',
  require 'kickstart.plugins.telescope',
  require 'kickstart.plugins.todo-comments',
  require 'kickstart.plugins.mini',
  require 'kickstart.plugins.treesitter',
  require 'kickstart.plugins.trouble',
  require 'kickstart.plugins.harpoon',
  require 'kickstart.plugins.grug-far',
  require 'kickstart.plugins.neogen',
  require 'kickstart.plugins.surround',

  -- UI
  require 'kickstart.plugins.colourscheme',
  require 'kickstart.plugins.indent-line',
  require 'kickstart.plugins.neo-tree',
  require 'kickstart.plugins.lualine',
  require 'kickstart.plugins.treesitter-context',
  require 'kickstart.plugins.auto-session',
  require 'kickstart.plugins.noice',
  require 'kickstart.plugins.snacks',

  -- Terminal
  require 'kickstart.plugins.toggleterm',

  -- Markdown
  require 'kickstart.plugins.render-markdown',
  require 'kickstart.plugins.preview-markdown',

  -- Language-specific
  require 'kickstart.plugins.vimtex',
  require 'kickstart.plugins.unreal',

  require 'kickstart.plugins.debug',
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et
