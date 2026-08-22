# Vim

A personal Neovim configuration, derived from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim), using [lazy.nvim](https://github.com/folke/lazy.nvim) as the plugin manager.

## Structure

```
init.lua                       -- entrypoint: leader keys, then requires below
lua/
  options.lua                  -- vim.o/vim.opt settings
  keymaps.lua                  -- basic keymaps and autocommands
  lazy-bootstrap.lua           -- bootstraps lazy.nvim itself
  lazy-plugins.lua             -- master plugin list (require('lazy').setup{...})
  kickstart/
    plugins/*.lua               -- one file per plugin/feature
    health.lua                  -- :checkhealth provider
syntax/sarl.vim                -- hand-written syntax highlighting for SARL
flake.nix                      -- Home Manager module (see Deployment below)
stylua.toml                    -- Lua formatter config
```

Plugins are added by dropping a new file in `lua/kickstart/plugins/` (returning a `lazy.nvim` plugin spec) and adding a `require 'kickstart.plugins.<name>'` line to `lua/lazy-plugins.lua`.

## Features

- **LSP**: `mason.nvim` + `mason-lspconfig.nvim` declaratively install and enable `lua_ls`, `jdtls`, and `bashls`. `clangd` is configured (`--clang-tidy`) but deliberately left out of Mason's `ensure_installed` so it stays the system/toolchain-matched binary Unreal Engine projects expect. LSP keymaps (`grd`, `grr`, `gri`, `grt`, `gO`, `gW`, `grn`, `gra`, `grD`, hover, inlay hints) are wired via an `LspAttach` autocommand, upgraded to Telescope pickers where useful.
- **Completion**: [`blink.cmp`](https://github.com/Saghen/blink.cmp) for LSP/path/snippet completion (`super-tab` preset), plus [`supermaven-nvim`](https://github.com/supermaven-inc/supermaven-nvim) for inline AI ghost-text suggestions (`<C-l>` to accept, rebound off `<Tab>` to avoid clashing with blink.cmp).
- **Formatting & linting**: `conform.nvim` (`stylua` for Lua) autoformats on save; `nvim-lint` + `mason-tool-installer` run `markdownlint`, `cppcheck`, and `shellcheck` on relevant filetypes.
- **Unreal Engine**: [`UnrealEngine.nvim`](https://github.com/mbwilding/UnrealEngine.nvim) wired up with `<leader>u*` keymaps to generate LSP info, build/rebuild, clean, and open the editor for UE projects.
- **LaTeX**: `vimtex`, using Zathura as the PDF viewer.
- **Markdown**: both in-buffer rendering (`render-markdown.nvim`) and browser-based live preview (`markdown-preview.nvim`).
- **SARL**: a custom syntax file (`syntax/sarl.vim`) for the SARL language, registered via a `sarl` filetype extension in `lua/options.lua`.
- Standard kickstart.nvim editing/UI stack: `telescope.nvim`, `treesitter`, `which-key`, `gitsigns`, `neo-tree`, `lualine`, `trouble`, `todo-comments`, `mini.nvim` (textobjects/surround), `nvim-autopairs`, `nightfox.nvim` (`carbonfox`).

## Deployment

This checkout is run directly with `NVIM_APPNAME=Vim nvim` and is pulled in by a separate home-manager flake. `flake.nix` exposes `homeManagerModules.nvimConfig`, which symlinks this repo to `~/.config/nvim` for that setup.

## Getting started

1. Open Neovim (`NVIM_APPNAME=Vim nvim`) — `lazy.nvim` bootstraps itself and installs plugins on first launch.
2. `:Lazy sync` to install/update plugins.
3. `:Mason` to check/install LSP servers, formatters, and linters.
4. `:checkhealth` to verify everything is wired up correctly.
