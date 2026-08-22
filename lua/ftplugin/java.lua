-- Sourced automatically by Neovim for every `java` buffer. nvim-jdtls needs
-- per-project workspace/root-dir state, which is why this lives here rather
-- than in the generic servers table in kickstart.plugins.lspconfig.
local jdtls = require 'jdtls'

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.stdpath 'data' .. '/jdtls-workspace/' .. project_name

local mason_registry = require 'mason-registry'
local jdtls_path = mason_registry.get_package('jdtls'):get_install_path()

local bundles = {}
local function add_bundle_jars(pkg_name, glob)
  local ok, pkg = pcall(mason_registry.get_package, pkg_name)
  if ok and pkg:is_installed() then
    vim.list_extend(bundles, vim.split(vim.fn.glob(pkg:get_install_path() .. glob), '\n'))
  end
end
add_bundle_jars('java-debug-adapter', '/extension/server/com.microsoft.java.debug.plugin-*.jar')
add_bundle_jars('java-test', '/extension/server/*.jar')

local config = {
  cmd = {
    'java',
    '-jar', vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar'),
    '-configuration', jdtls_path .. '/config_linux',
    '-data', workspace_dir,
  },
  root_dir = require('jdtls.setup').find_root { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' },
  capabilities = require('blink.cmp').get_lsp_capabilities(),
  init_options = { bundles = bundles },
  on_attach = function()
    jdtls.setup_dap { hotcodereplace = 'auto' }
    require('jdtls.dap').setup_dap_main_class_configs()
  end,
}

jdtls.start_or_attach(config)
-- vim: ts=2 sts=2 sw=2 et
