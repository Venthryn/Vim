return {
  "barreiroleo/ltex_extra.nvim",
  ft = { "markdown", "text", "tex", "gitcommit" }, -- match your ltex filetypes
  dependencies = { "neovim/nvim-lspconfig" },
  init = function()
    -- Where per-project dictionaries/disabled-rules get written on disk.
    -- Defaults to a `.ltex` folder next to your files if you don't set this;
    -- pointing it somewhere fixed keeps additions in one place.
    vim.g.ltex_extra_path = vim.fn.expand("~/.config/nvim/ltex")
  end,
}
