return {
  "rebelot/kanagawa.nvim",
  lazy = false, -- Load immediately
  priority = 1000, -- Load before other plugins
  opts = {
    -- Optional configuration here
    background = { dark = "wave", light = "lotus" },
  },
  config = function(_, opts)
    require("kanagawa").setup(opts)
    vim.cmd("colorscheme kanagawa")
  end,
}
