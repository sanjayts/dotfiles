return {
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      {
        "<leader>gd",
        function()
          if next(require("diffview.lib").views) == nil then
            vim.cmd("DiffviewOpen")
          else
            vim.cmd("DiffviewClose")
          end
        end,
        desc = "Toggle diff vs index",
      },
      {
        "<leader>gD",
        function()
          if next(require("diffview.lib").views) == nil then
            vim.cmd("DiffviewOpen master")
          else
            vim.cmd("DiffviewClose")
          end
        end,
        desc = "Toggle diff vs master",
      },
      {
        "<leader>gB",
        function()
          if next(require("diffview.lib").views) ~= nil then
            vim.cmd("DiffviewClose")
          end
          Snacks.picker.git_branches({
            all = true,
            format = function(item, picker)
              local ret = {}
              local branch = item.branch or item.text or ""
              if item.current then
                ret[#ret + 1] = { "* ", "SnacksPickerGitBranchCurrent" }
              else
                ret[#ret + 1] = { "  " }
              end
              ret[#ret + 1] = { branch, item.current and "SnacksPickerGitBranchCurrent" or "SnacksPickerGitBranch" }
              return ret
            end,
            win = {
              list = {
                wo = {
                  wrap = true,
                },
              },
            },
            confirm = function(picker, item)
              picker:close()
              if item then
                local branch = item.branch or item.text
                branch = branch:gsub("^%s+", ""):gsub("^%*%s+", "")
                vim.cmd("DiffviewOpen " .. branch)
              end
            end,
          })
        end,
        desc = "Diff vs branch (pick from list)",
      },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history (current file)" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "File history (all files)" },
      { "<leader>gc", "<cmd>DiffviewClose<cr>", desc = "Close diffview" },
    },
    opts = {
      enhanced_diff_hl = true,
      -- --imply-local: use real file paths for working-tree side so LSP works there
      -- (left/historical side still uses diffview:// URIs; LspAttach detach handles those)
      default_args = {
        DiffviewOpen = { "--imply-local" },
      },
      view = {
        default = {
          winbar_info = true,
          disable_diagnostics = true,
        },
        merge_tool = {
          disable_diagnostics = true,
        },
        file_history = {
          winbar_info = true,
          disable_diagnostics = true,
        },
      },
    },
  },
  -- Override gitsigns to not steal <leader>gd
  {
    "lewis6991/gitsigns.nvim",
    opts = function(_, opts)
      local default_on_attach = opts.on_attach
      opts.on_attach = function(buffer)
        if default_on_attach then
          default_on_attach(buffer)
        end
        vim.keymap.set("n", "<leader>gd", function()
          if next(require("diffview.lib").views) == nil then
            vim.cmd("DiffviewOpen")
          else
            vim.cmd("DiffviewClose")
          end
        end, { buffer = buffer, desc = "Toggle diff vs index (diffview)" })
      end
      return opts
    end,
  },
}
