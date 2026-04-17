-- Auto-save session state every 5 minutes while NeoVim is running.
-- Protects against losing workspace layout (buffers, windows, tabs) on crash.
-- Works alongside persistence.nvim's normal save-on-quit behavior.
--
-- Only saves when there are 2+ real file buffers open. This prevents a quick
-- single-file edit (e.g., `nvim ~/.zshrc`) from overwriting a multi-buffer
-- workspace session that was previously saved for the same directory.

local MIN_BUFFERS = 3 -- don't overwrite a workspace session for a quick edit

local function count_file_buffers()
  local count = 0
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" and vim.api.nvim_buf_get_name(buf) ~= "" then
      count = count + 1
    end
  end
  return count
end

return {
  "folke/persistence.nvim",
  opts = function(_, opts)
    local timer = nil
    local interval_ms = 5 * 60 * 1000 -- 5 minutes

    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        vim.defer_fn(function()
          timer = vim.uv.new_timer()
          timer:start(interval_ms, interval_ms, vim.schedule_wrap(function()
            if count_file_buffers() < MIN_BUFFERS then
              return -- skip save for single-file edits
            end
            local ok, err = pcall(function()
              require("persistence").save()
            end)
            if not ok then
              vim.notify("Session autosave failed: " .. tostring(err), vim.log.levels.WARN)
            end
          end))
        end, 1000)
      end,
    })

    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function()
        if timer then
          timer:stop()
          timer:close()
        end
      end,
    })

    return opts
  end,
}
