return {
  'MagicDuck/grug-far.nvim',
  cmd = 'GrugFar',
  keys = {
    {
      '<leader>r',
      function()
        require('grug-far').open()
      end,
      desc = '[R]eplace (project-wide)',
    },
  },
  opts = {},
}
-- vim: ts=2 sts=2 sw=2 et
