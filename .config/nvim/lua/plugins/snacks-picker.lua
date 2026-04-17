-- Custom diagnostic format function shared by both diagnostics sources
local function diagnostic_format(item, picker)
  local ret = {}
  local diag = item.item

  -- 1. Severity icon
  if item.severity then
    vim.list_extend(ret, Snacks.picker.format.severity(item, picker))
  end

  -- 2. Filename with position (moved to front)
  vim.list_extend(ret, Snacks.picker.format.filename(item, picker))
  ret[#ret + 1] = { " " }

  -- 3. Diagnostic message
  local message = diag.message
  ret[#ret + 1] = { message }
  Snacks.picker.highlight.markdown(ret)

  -- 4. Source and code (if available)
  if diag.source then
    ret[#ret + 1] = { " " }
    ret[#ret + 1] = { diag.source, "SnacksPickerDiagnosticSource" }
  end
  if diag.code then
    ret[#ret + 1] = { " " }
    ret[#ret + 1] = { ("(%s)"):format(diag.code), "SnacksPickerDiagnosticCode" }
  end

  return ret
end

local diagnostic_win = {
  list = {
    wo = {
      wrap = true,
    },
  },
}

return {
  {
    "folke/snacks.nvim",
    opts = {
      -- Bigfile thresholds: disable heavy features (treesitter, LSP) above these
      -- Default was 1.5MB/1000 chars -- raised to handle normal large files
      -- without freezing on truly huge ones
      bigfile = {
        size = 1024 * 1024 * 5,     -- 5MB
        line_length = 5000,          -- catches minified files but not normal JSON
      },
      -- Floating terminal by default
      terminal = {
        win = {
          style = "float",
        },
      },
      picker = {
        -- Tab cycles between input, file list, and preview pane
        win = {
          input = {
            keys = {
              ["<Tab>"] = { "cycle_win", mode = { "i", "n" } },
            },
          },
          list = {
            keys = {
              ["<Tab>"] = "cycle_win",
            },
          },
          preview = {
            keys = {
              ["<Tab>"] = "cycle_win",
            },
          },
        },
        sources = {
          -- Show hidden files in file picker
          files = {
            hidden = true,
          },
          -- <leader>sd: workspace diagnostics
          diagnostics = {
            format = diagnostic_format,
            win = diagnostic_win,
          },
          -- <leader>sD: buffer diagnostics
          diagnostics_buffer = {
            format = diagnostic_format,
            win = diagnostic_win,
          },
        },
      },
    },
  },
}
