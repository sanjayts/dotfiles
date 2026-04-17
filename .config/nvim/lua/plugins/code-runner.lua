return {
  {
    "CRAG666/code_runner.nvim",
    keys = {
      { "<leader>ro", "<cmd>RunCode<cr>", desc = "Run file" },
      { "<leader>rp", "<cmd>RunProject<cr>", desc = "Run project" },
      { "<leader>rc", "<cmd>RunClose<cr>", desc = "Close runner" },
    },
    opts = {
      filetype = {
        go = "cd $dir && go run .",
        rust = "cd $dir && cargo run",
        ruby = "ruby $file",
        python = "python3 $file",
        javascript = "node $file",
        typescript = "npx ts-node $file",
        lua = "lua $file",
        sh = "bash $file",
      },
      -- Run in a horizontal split terminal
      mode = "term",
      startinsert = true,
    },
  },
}
