return {
  {
    "nvim-neotest/neotest",
    opts = {
      output_panel = {
        enabled = true,
        -- Open at the bottom with a reasonable height
        open = "botright split | resize 20",
      },
      -- Show short output inline after test runs
      output = {
        open_on_run = false,
      },
    },
    keys = {
      -- Run test and show live output in one keypress
      {
        "<leader>tl",
        function()
          -- Clear the output panel buffer before running
          local panels = require("neotest.consumers.output_panel")
          panels.clear()
          -- Open the panel
          panels.open()
          -- Run the nearest test
          require("neotest").run.run()
        end,
        desc = "Run test with live output",
      },
    },
  },
}
