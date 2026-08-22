return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  opts = {
    options = {
      theme = 'carbonfox',
      component_separators = '',
      section_separators = { left = '', right = '' },
    },
    sections = {
      lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 } },
      lualine_b = {
        -- no explicit icon: lualine's branch component already defaults to
        -- a sensible glyph once vim.g.have_nerd_font is true (set in init.lua)
        { 'branch', separator = { left = '', right = '' }, padding = { left = 1, right = 1 } },
        { 'diff', separator = { left = '', right = '' }, padding = { left = 0, right = 1 } },
      },
      lualine_c = { { 'filename', path = 1 } },
      lualine_x = {
        {
          'diagnostics',
          sections = { 'error', 'warn', 'info', 'hint' },
          separator = { left = '', right = '' },
          padding = { left = 1, right = 1 },
        },
        'filetype',
      },
      lualine_y = { 'progress' },
      lualine_z = { { 'location', separator = { right = '' }, left_padding = 2 } },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
