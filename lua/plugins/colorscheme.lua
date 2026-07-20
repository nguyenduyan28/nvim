return {
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    lazy = false,
    priority = 1000,
    config = function()
      vim.o.background = "light"
      require("github-theme").setup({})
      vim.cmd.colorscheme("github_light_colorblind")
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    priority = 999,
  },
}
