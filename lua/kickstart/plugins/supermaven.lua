return {
  'supermaven-inc/supermaven-nvim',
  event = 'VimEnter',
  opts = {
    keymaps = {
      -- Default accept_suggestion is <Tab>, which clashes with blink.cmp's
      -- 'super-tab' preset (Tab selects/accepts blink's own menu and jumps
      -- snippet placeholders). Rebind Supermaven's ghost-text accept to <C-l>.
      accept_suggestion = '<C-l>',
      clear_suggestion = '<C-]>',
      accept_word = '<C-j>',
    },
    disable_inline_completion = false,
    disable_keymaps = false,
    ignore_filetypes = {},
  },
}
-- vim: ts=2 sts=2 sw=2 et
