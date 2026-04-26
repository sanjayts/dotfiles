return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    -- Use the ":call ..." string form (not the function form) so lazy.nvim
    -- runs the install through Vim's command line. That forces the plugin's
    -- autoload/mkdp/util.vim to be sourced before the function is invoked;
    -- the plain `vim.fn["mkdp#util#install"]()` form races autoload on a
    -- cold install and fails with `E117: unknown function`.
    build = ":call mkdp#util#install()",
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
