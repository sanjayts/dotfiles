-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Auto-reload markdown files when modified externally (for live preview to update
-- when Claude Code or other tools edit the file in the background)
local md_group = vim.api.nvim_create_augroup("MarkdownAutoReload", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = md_group,
  pattern = "markdown",
  callback = function(args)
    local timer = vim.uv.new_timer()
    timer:start(1000, 1000, vim.schedule_wrap(function()
      if vim.api.nvim_buf_is_valid(args.buf) then
        vim.api.nvim_buf_call(args.buf, function()
          vim.cmd("silent! checktime")
        end)
      else
        timer:stop()
        timer:close()
      end
    end))
    vim.api.nvim_create_autocmd("BufDelete", {
      group = md_group,
      buffer = args.buf,
      callback = function()
        timer:stop()
        if not timer:is_closing() then timer:close() end
      end,
    })
  end,
})

-- Prevent LSP attach on diffview:// / fugitive:// buffers.
-- gopls (and some others) reject non-'file' DocumentURIs since late 2023 with error -32700.
-- vim.schedule defers the detach to the next event loop tick so the attach completes first --
-- otherwise buf_detach_client is a no-op because the client isn't fully registered yet.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("DiffviewDetachLSP", { clear = true }),
  callback = function(args)
    local bufname = vim.api.nvim_buf_get_name(args.buf)
    if bufname:match("^diffview://") or bufname:match("^fugitive://") then
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(args.buf) then
          vim.lsp.buf_detach_client(args.buf, args.data.client_id)
        end
      end)
    end
  end,
})


