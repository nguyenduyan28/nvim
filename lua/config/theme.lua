local M = {}

M.default = "onedark"
M.current = nil

M.themes = {
  ghostty = {
    label = "Ghostty Default Style Dark",
    setup = function()
      require("ghostty-default-style-dark").setup({})
    end,
    load = function()
      vim.cmd.colorscheme("ghostty-default-style-dark")
    end,
  },
  vscode = {
    label = "VSCode Dark",
    setup = function()
      require("vscode").setup({
        style = "dark",
      })
    end,
    load = function()
      vim.cmd.colorscheme("vscode")
    end,
  },
  github = {
    label = "GitHub Light",
    background = "light",
    setup = function()
      require("github-theme").setup({})
    end,
    load = function()
      vim.cmd.colorscheme("github_light")
    end,
  },
  kanagawa = {
    label = "Kanagawa Dragon",
    setup = function()
      require("kanagawa").setup({})
    end,
    load = function()
      vim.cmd.colorscheme("kanagawa-dragon")
    end,
  },
  onedark = {
    label = "OneDark Warmer",
    setup = function()
      require("onedark").setup({
        style = "warmer",
      })
    end,
    load = function()
      require("onedark").load()
    end,
  },
  rosepine = {
    label = "Rose Pine",
    setup = function()
      require("rose-pine").setup({
        variant = "auto",
        dark_variant = "main",
      })
    end,
    load = function()
      vim.cmd.colorscheme("rose-pine")
    end,
  },
  carbonfox = {
    label = "Dawnfox",
    setup = function()
      require("nightfox").setup({})
    end,
    load = function()
      vim.cmd.colorscheme("dawnfox")
    end,
  },
}

function M.names()
  local names = vim.tbl_keys(M.themes)
  table.sort(names)
  return names
end

function M.apply(name, opts)
  opts = opts or {}

  local theme = M.themes[name]
  if not theme then
    vim.notify(("Unknown theme: %s"):format(name), vim.log.levels.ERROR)
    return false
  end

  vim.o.background = theme.background or "dark"
  theme.setup()
  theme.load()

  M.current = name

  if not opts.silent then
    vim.notify(("Theme changed to %s"):format(theme.label))
  end

  return true
end

function M.select()
  vim.ui.select(M.names(), {
    prompt = "Select theme",
    format_item = function(name)
      return M.themes[name].label
    end,
  }, function(choice)
    if choice then
      M.apply(choice)
    end
  end)
end

function M.setup()
  vim.api.nvim_create_user_command("ThemeSelect", function()
    M.select()
  end, { desc = "Select theme", force = true })

  vim.api.nvim_create_user_command("ThemeSet", function(args)
    M.apply(args.args)
  end, {
    nargs = 1,
    complete = function()
      return M.names()
    end,
    desc = "Set theme",
    force = true,
  })

  M.apply(M.default, { silent = true })
end

return M
