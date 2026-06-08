return {
  "lewis6991/satellite.nvim",
  dependencies = { "lewis6991/gitsigns.nvim" },
  config = function()
    require("satellite").setup({
      -- Thin scrollbar on the right edge with markers for the whole file
      handlers = {
        gitsigns = { enable = true }, -- git added/changed/deleted ticks
        diagnostic = { enable = true }, -- LSP error/warning ticks
        search = { enable = true }, -- search match ticks
        marks = { enable = true },
      },
    })
  end,
}
