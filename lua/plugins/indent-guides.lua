return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local hooks = require("ibl.hooks")

    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "IndentGuide", { fg = "#343a40" })
      vim.api.nvim_set_hl(0, "IndentScope", { fg = "#5c6370" })
    end)

    require("ibl").setup({
      indent = {
        char = "│",
        highlight = "IndentGuide",
      },
      scope = {
        enabled = true,
        char = "│",
        highlight = "IndentScope",
        show_start = false,
        show_end = false,
      },
      exclude = {
        filetypes = {
          "help",
          "lazy",
          "mason",
          "NvimTree",
          "TelescopePrompt",
          "terminal",
        },
      },
    })
  end,
}
