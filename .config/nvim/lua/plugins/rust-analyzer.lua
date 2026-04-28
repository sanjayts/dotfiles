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
            imports = {
              -- Group imports by module: `use foo::bar::{Baz, Qux};` rather than separate lines
              granularity = { group = "module" },
              -- Prefer `self::` prefix for relative imports
              prefix = "self",
            },
          },
        },
      },
    },
  },
}
