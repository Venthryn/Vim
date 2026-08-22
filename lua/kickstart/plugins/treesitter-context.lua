return {
  'nvim-treesitter/nvim-treesitter-context',
  event = 'VeryLazy',
  opts = {},
  keys = {
    {
      '<leader>tc',
      function()
        require('treesitter-context').toggle()
      end,
      desc = '[T]oggle [C]ontext (sticky scroll)',
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
