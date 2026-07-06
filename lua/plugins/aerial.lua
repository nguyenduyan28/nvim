local sysname = (vim.uv or vim.loop).os_uname().sysname
local primary_mod = sysname == "Darwin" and "D" or "C"

return {
  "stevearc/aerial.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  cmd = {
    "AerialToggle",
    "AerialOpen",
    "AerialClose",
    "AerialInfo",
  },
  keys = {
    { ("<%s-S-b>"):format(primary_mod), "<cmd>AerialToggle!<cr>", mode = { "n", "i", "v" }, desc = "Toggle symbols outline" },
  },
  opts = {
    layout = {
      default_direction = "prefer_right",
    },
  },
}
