-- Treesitter-based doc-comment generation for functions/classes (reads the
-- actual signature to stub @param/@return). Doesn't cover plain member
-- variables at all (no extractor for that in its c/cpp config), so that
-- case is handled separately below via an ad-hoc LuaSnip expansion instead.
--
-- Doxygen-style output isn't UE's own documented convention (Epic's coding
-- standard describes a JavaDoc-like style: @param/@warning/@note/@see/
-- @deprecated, no @brief), but UHT's tooltip parser is comment-format-
-- agnostic — plain or Doxygen-style comments above UPROPERTY/UFUNCTION both
-- populate editor tooltips fine, so the default doxygen convention works.
return {
  'danymat/neogen',
  keys = {
    {
      '<leader>cf',
      function()
        require('neogen').generate { type = 'func' }
      end,
      desc = '[C]omment [F]unction/Method',
    },
    {
      '<leader>cc',
      function()
        require('neogen').generate { type = 'class' }
      end,
      desc = '[C]omment [C]lass',
    },
    {
      '<leader>cv',
      function()
        require('luasnip').lsp_expand('/** ${1:Description} */')
      end,
      desc = '[C]omment [V]ariable',
    },
  },
  opts = {},
}
-- vim: ts=2 sts=2 sw=2 et
