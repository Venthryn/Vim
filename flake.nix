{
  description = "Neovim Config";

  outputs = { self }: {
    homeManagerModules.nvimConfig = { pkgs, ... }: {
      programs.neovim.enable = true;
      home.file.".config/nvim".source = self;

      home.packages = with pkgs; [
        # Baseline kickstart.nvim requirements (see lua/kickstart/health.lua)
        git
        gnumake
        unzip
        ripgrep
        fd # optional, but recommended alongside ripgrep for Telescope

        # Compiler toolchain: builds treesitter parsers (:TSUpdate),
        # LuaSnip's jsregexp (blink-cmp.lua), telescope-fzf-native (telescope.lua)
        gcc

        # clangd: deliberately NOT Mason-managed in kickstart.plugins.lspconfig,
        # so it stays a toolchain-matched system install for Unreal Engine's
        # generated compile_commands.json
        clang-tools

        # nvim-jdtls (Mason-installed) needs a JVM on PATH to actually run
        jdk

        # kickstart.plugins.lint: cppcheck has no Mason package
        cppcheck

        # kickstart.plugins.toggleterm's lazygit floating terminal
        lazygit

        # kickstart.plugins.vimtex: PDF viewer + LaTeX compiler (latexmk)
        zathura
        texliveMedium
      ];
    };
  };
}
