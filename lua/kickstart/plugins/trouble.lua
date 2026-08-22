return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('trouble').setup {}
  end,
}
-- vim: ts=2 sts=2 sw=2 et
