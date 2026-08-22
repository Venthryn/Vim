local lazygit_term

local function toggle_lazygit()
  if not lazygit_term then
    local Terminal = require('toggleterm.terminal').Terminal
    lazygit_term = Terminal:new {
      cmd = 'lazygit',
      hidden = true,
      direction = 'float',
      float_opts = { border = 'curved' },
      on_open = function(term)
        vim.cmd 'startinsert!'
        vim.keymap.set('t', 'q', '<cmd>close<CR>', { buffer = term.bufnr, silent = true })
      end,
    }
  end
  lazygit_term:toggle()
end

return {
  'akinsho/toggleterm.nvim',
  version = '*',
  cmd = { 'ToggleTerm', 'TermExec' },
  keys = {
    -- Pulled out of <leader>t (Toggle) into its own group: <leader>t was
    -- accumulating unrelated toggles (git/LSP/treesitter/terminal) with no
    -- structure. Backtick is the conventional terminal/shell mnemonic.
    { '<leader>`t', '<cmd>ToggleTerm<CR>', desc = 'Terminal' },
    { '<leader>`g', toggle_lazygit, desc = 'Lazygit' },
  },
  opts = {
    -- Explicitly disabled rather than left at the factory default: the
    -- default global toggle is <C-\> in normal/insert/terminal modes,
    -- which would compete with the <C-\><C-n> terminal-escape sequence
    -- keymaps.lua already has a dedicated <Esc><Esc> convenience map for.
    open_mapping = false,
    direction = 'float',
    float_opts = { border = 'curved' },
  },
}
-- vim: ts=2 sts=2 sw=2 et
