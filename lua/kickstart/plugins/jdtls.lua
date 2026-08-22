-- The actual setup (workspace dir, DAP bundles, start_or_attach) lives in
-- lua/ftplugin/java.lua, since jdtls needs per-project state the generic
-- vim.lsp.enable() loop in lspconfig.lua can't provide. The jdtls binary
-- itself is installed via kickstart.plugins.lint's mason-tool-installer list.
return {
  'mfussenegger/nvim-jdtls',
  ft = 'java',
}
-- vim: ts=2 sts=2 sw=2 et
