return {
  {
    "jiaoshijie/undotree",
    dependencies = "nvim-lua/plenary.nvim",
    keys = {
      { "<leader>U", function() require("undotree").toggle() end, desc = "Toggle undo tree" },
    },
    opts = {},
  },
}
