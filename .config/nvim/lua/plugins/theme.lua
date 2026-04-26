-- ─── Theme Configuration ────────────────────────────
-- To switch themes: change the `active_theme` value below and restart Neovim.
-- Only the active theme actually loads at startup; others are installed but
-- lazy-loaded (loaded on demand when you run `:colorscheme <name>`).
--
-- This prevents conflicts where unused themes leave behind persistent
-- highlight groups that bleed into the active theme.
--
-- Available themes:
--   "sonokai"           (sainnhe/sonokai) -- warm dark, "espresso" style closest to Apprentice
--   "everforest"        (sainnhe/everforest) -- warm greens/yellows, eye-friendly
--   "gruvbox-material"  (sainnhe/gruvbox-material) -- warm, muted, Apprentice-like
--   "gruvbox"           (ellisonleao/gruvbox.nvim)
--   "kanagawa"          (rebelot/kanagawa.nvim)
--   "rose-pine"         (rose-pine/neovim)

local active_theme = "sonokai"

-- Helper: each theme plugin spec only loads eagerly if it's the active one
local function theme(name, spec)
  spec.lazy = (active_theme ~= name)
  spec.priority = spec.lazy and nil or 1000
  return spec
end

return {
  -- Sonokai (warm dark, "espresso" style is warmest)
  theme("sonokai", {
    "sainnhe/sonokai",
    config = function()
      vim.g.sonokai_style = "maia"  -- default | atlantis | andromeda | shusia | maia | espresso
      vim.g.sonokai_better_performance = 1
    end,
  }),

  -- Everforest
  theme("everforest", {
    "sainnhe/everforest",
    config = function()
      vim.g.everforest_background = "soft"
      vim.g.everforest_better_performance = 1
    end,
  }),

  -- Gruvbox Material
  theme("gruvbox-material", {
    "sainnhe/gruvbox-material",
    config = function()
      vim.g.gruvbox_material_background = "medium"
      vim.g.gruvbox_material_foreground = "material"
      vim.g.gruvbox_material_better_performance = 1
    end,
  }),

  -- Gruvbox
  theme("gruvbox", {
    "ellisonleao/gruvbox.nvim",
    opts = {
      contrast = "soft",  -- "hard" | "" (medium) | "soft"
    },
  }),

  -- Kanagawa
  theme("kanagawa", {
    "rebelot/kanagawa.nvim",
    opts = {
      background = { dark = "wave", light = "lotus" },
    },
  }),

  -- Rose Pine
  theme("rose-pine", {
    "rose-pine/neovim",
    name = "rose-pine",
  }),

  -- Activate the selected theme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = active_theme,
    },
  },
}
