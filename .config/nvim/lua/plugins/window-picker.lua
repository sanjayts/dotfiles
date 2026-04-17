return {
  {
    "s1n7ax/nvim-window-picker",
    version = "2.*",
    keys = {
      {
        "<leader>ww",
        function()
          local win_id = require("window-picker").pick_window()
          if win_id then
            vim.api.nvim_set_current_win(win_id)
          end
        end,
        desc = "Pick a window",
      },
    },
    opts = {
      hint = "floating-big-letter",
      filter_rules = {
        -- Include all windows including floating
        include_current_win = false,
        bo = {
          filetype = { "notify" },
          buftype = {},
        },
      },
    },
  },
}
