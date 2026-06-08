return {
  "rebelot/kanagawa.nvim",
  lazy = false, -- load during startup
  priority = 1000, -- load before other plugins so highlights apply
  config = function()
    require("kanagawa").setup({
      compile = false,
      theme = "dragon", -- darker, near-black variant (vs blue-tinted "wave")
      background = {
        dark = "dragon",
      },
    })
    vim.cmd.colorscheme("kanagawa-dragon")
  end,
}
