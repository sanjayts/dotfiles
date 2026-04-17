return {
  {
    "levouh/tint.nvim",
    event = "WinNew",
    opts = {
      tint = -30,           -- darken inactive windows by this amount (-100 to 100)
      saturation = 0.7,     -- slightly desaturate inactive windows
      tint_background_colors = true,
    },
  },
}
