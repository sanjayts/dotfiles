return {
  {
    "mrcjkb/rustaceanvim",
    opts = {
      server = {
        default_settings = {
          ["rust-analyzer"] = {
            references = {
              -- Filter out references inside #[test] functions from "Find References" results
              excludeTests = true,
              -- Also filter out import statements from references
              excludeImports = true,
            },
          },
        },
      },
    },
  },
}
