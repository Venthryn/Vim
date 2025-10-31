{
  description = "Neovim Config";

  outputs = { self }: {
    homeManagerModules.nvimConfig = {
      programs.neovim.enable = true;
      home.file.".config/nvim".source = self;
    };
  };
}
