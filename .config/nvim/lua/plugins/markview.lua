return {
  -- Disable the default render-markdown from LazyVim's markdown extra
  { "MeanderingProgrammer/render-markdown.nvim", enabled = false },

  -- Use markview.nvim instead (prettier Obsidian-style rendering)
  {
    "OXY2DEV/markview.nvim",
    ft = { "markdown", "quarto", "rmd" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {},
  },
}
