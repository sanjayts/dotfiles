return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    config = function()
      -- Live auto-refresh as you edit (instead of refreshing only on save)
      -- Note: browser refresh (Cmd+R) will 404 due to known plugin bug #685 --
      -- just rely on the live auto-refresh and don't manually reload
      vim.g.mkdp_refresh_slow = 0
      -- Keep preview server alive when switching buffers
      vim.g.mkdp_auto_close = 0
    end,
  },
}
