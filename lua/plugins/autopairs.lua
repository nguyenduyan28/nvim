return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    require("nvim-autopairs").setup({
      check_ts = true, -- use treesitter to be context-aware
      fast_wrap = {}, -- enable default fast-wrap mappings
    })
  end,
}
