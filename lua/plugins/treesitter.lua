return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main", -- the version compatible with Neovim 0.11+/0.12 (master is EOL)
  build = ":TSUpdate",
  lazy = false,
  config = function()
    -- Install parsers (async; no-op if already installed)
    require("nvim-treesitter").install({
      "typescript",
      "tsx",
      "javascript",
      "json",
      "lua",
      "vim",
      "markdown",
      "markdown_inline",
    })

    -- Highlighting is provided by Neovim core; enable it per filetype.
    -- (Indentation is left to Neovim's built-in indenters, e.g. GetTypescriptIndent.)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "typescript",
        "typescriptreact",
        "javascript",
        "javascriptreact",
        "json",
        "lua",
        "vim",
        "markdown",
      },
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })
  end,
}
