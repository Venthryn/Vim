return {
  'rmagatti/auto-session',
  lazy = false,
  opts = {
    suppressed_dirs = { '~/', '~/Downloads', '/' },
    -- Close neo-tree before saving so it's never part of the saved window
    -- layout; otherwise a restored session's Neo-tree window can end up
    -- duplicated alongside neo-tree's own netrw-hijack auto-open.
    pre_save_cmds = {
      function()
        pcall(vim.cmd, 'Neotree close')
      end,
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
