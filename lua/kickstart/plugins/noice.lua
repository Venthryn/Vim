return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = {
    'MunifTanjim/nui.nvim', -- already present via neo-tree.lua; harmless to re-list
    'rcarriga/nvim-notify',
  },
  opts = {
    lsp = {
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      lsp_doc_border = true,
    },
    -- noice's popupmenu view targets nvim-cmp/wildmenu-style completion;
    -- this repo uses blink.cmp for its own popup, so leave noice's alone
    -- to avoid two competing completion-menu renderers.
    popupmenu = { enabled = false },
  },
}
-- vim: ts=2 sts=2 sw=2 et
