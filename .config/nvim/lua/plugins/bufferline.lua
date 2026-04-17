return {
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        indicator = {
          style = "icon",
          icon = "▎",
        },
        -- Show full filenames, only truncate when space runs out
        max_name_length = 50,
        max_prefix_length = 30,
        tab_size = 10,
        truncate_names = false,
      },
      highlights = {
        -- Make the active buffer bold with a distinct background
        buffer_selected = {
          bold = true,
          italic = false,
        },
        -- Make the indicator visible
        indicator_selected = {
          fg = "#f6c177",
        },
      },
    },
  },
}
