-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Swap jump back/forward to match Ctrl+[ / Ctrl+] mental model
vim.keymap.set("n", "<C-i>", "<C-o>", { desc = "Jump back" })
vim.keymap.set("n", "<C-o>", "<C-i>", { desc = "Jump forward" })

-- Quick escape from insert mode
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })
vim.keymap.set("i", "kj", "<Esc>", { desc = "Exit insert mode" })
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode" })

-- Copy file path to clipboard
vim.keymap.set("n", "<leader>yp", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Copy full file path" })

-- Toggle markdown preview in browser
vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreview<cr>", { desc = "Markdown preview (browser)" })
vim.keymap.set("n", "<leader>mP", "<cmd>MarkdownPreviewStop<cr>", { desc = "Markdown preview stop" })

-- Find references including tests (gr excludes tests by default via rust-analyzer config)
-- Temporarily disables excludeTests, runs references, then re-enables it
vim.keymap.set("n", "gR", function()
  local clients = vim.lsp.get_clients({ name = "rust-analyzer" })
  for _, client in ipairs(clients) do
    client.settings["rust-analyzer"].references.excludeTests = false
    client.notify("workspace/didChangeConfiguration", { settings = client.settings })
  end
  Snacks.picker.lsp_references()
  -- Re-enable after a short delay to let the request go through
  vim.defer_fn(function()
    for _, client in ipairs(vim.lsp.get_clients({ name = "rust-analyzer" })) do
      client.settings["rust-analyzer"].references.excludeTests = true
      client.notify("workspace/didChangeConfiguration", { settings = client.settings })
    end
  end, 500)
end, { desc = "References (including tests)" })

-- Format JSON with jq (works even in bigfile mode)
vim.keymap.set("n", "<leader>fj", "<cmd>%!jq .<cr>", { desc = "Format JSON with jq" })
vim.keymap.set("n", "<leader>fJ", "<cmd>%!jq -S .<cr>", { desc = "Format JSON with sorted keys" })
