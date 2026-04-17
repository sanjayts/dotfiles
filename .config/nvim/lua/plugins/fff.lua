return {
  {
    "dmtrKovalenko/fff.nvim",
    build = function()
      require("fff.download").download_or_build_binary()
    end,
    keys = {
      { "<leader>fF", function() require("fff").find_files() end, desc = "fff: Fuzzy find files" },
      { "<leader>sg", function() require("fff").live_grep() end, desc = "fff: Grep" },
    },
    opts = {},
  },
}
