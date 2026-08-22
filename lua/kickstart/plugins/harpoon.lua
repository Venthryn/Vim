return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    -- Grouped under <leader>m ("marks", harpoon's own term for a saved
    -- file) rather than a bare <leader>a + <C-e>, so it's one coherent,
    -- which-key-labeled group instead of two orphan mappings.
    {
      '<leader>ma',
      function()
        require('harpoon'):list():add()
      end,
      desc = '[M]ark [A]dd File',
    },
    {
      '<leader>mm',
      function()
        require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())
      end,
      desc = '[M]ark [M]enu',
    },
    {
      '<leader>m1',
      function()
        require('harpoon'):list():select(1)
      end,
      desc = '[M]ark 1',
    },
    {
      '<leader>m2',
      function()
        require('harpoon'):list():select(2)
      end,
      desc = '[M]ark 2',
    },
    {
      '<leader>m3',
      function()
        require('harpoon'):list():select(3)
      end,
      desc = '[M]ark 3',
    },
    {
      '<leader>m4',
      function()
        require('harpoon'):list():select(4)
      end,
      desc = '[M]ark 4',
    },
  },
  config = function()
    require('harpoon'):setup()
  end,
}
-- vim: ts=2 sts=2 sw=2 et
