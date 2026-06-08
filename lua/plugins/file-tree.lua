return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup({
      view = {
        width = 30,
      },
      renderer = {
        icons = {
          show = {
            file = true,
            folder = true,
            git = true,
          },
        },
      },
    })
  end,
}