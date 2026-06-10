return {
  "navarasu/onedark.nvim",
  lazy = false, -- load during startup
  priority = 1000, -- load before other plugins so highlights apply
  config = function()
    require("onedark").setup({
      style = "warmer",
    })
    require("onedark").load()
  end,
}
