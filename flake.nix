{
  description = "Neovim Config";
  outputs = { self }: {
    homeManagerModules.nvimConfig = { pkgs, ... }: {
      programs.neovim.enable = true;
      home.file.".config/nvim".source = self;

      home.packages = [
        pkgs.texliveFull
        pkgs.texlivePackages.latexmk
      ];
    };
  };
}
