return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local function dim_gitignored_highlights()
      local comment = vim.api.nvim_get_hl(0, { name = "Comment", link = false })
      local ignored = { fg = comment.fg or 0x6A737D, italic = true }

      for _, group in ipairs({
        "NvimTreeGitIgnoredIcon",
        "NvimTreeGitFileIgnoredHL",
        "NvimTreeGitFolderIgnoredHL",
      }) do
        vim.api.nvim_set_hl(0, group, ignored)
      end
    end

    local function my_on_attach(bufnr)
      local api = require("nvim-tree.api")
      local sysname = (vim.uv or vim.loop).os_uname().sysname
      local mod = sysname == "Darwin" and "D" or "C"

      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      api.config.mappings.default_on_attach(bufnr)

      vim.keymap.set("n", "%", api.fs.create, opts("Create file/folder"))
      vim.keymap.set("n", "r", api.fs.rename, opts("Rename"))
      vim.keymap.set("n", ("<%s-c>"):format(mod), api.fs.copy.node, opts("Copy"))
      vim.keymap.set("n", ("<%s-x>"):format(mod), api.fs.cut, opts("Cut"))
      vim.keymap.set("n", ("<%s-v>"):format(mod), api.fs.paste, opts("Paste"))
    end

    require("nvim-tree").setup({
      view = {
        width = 45,
      },
      on_attach = my_on_attach,
      update_focused_file = {
        enable = true,
      },
      filters = {
        dotfiles = false,
        git_ignored = false,
      },
      renderer = {
        highlight_git = "all",
        icons = {
          show = {
            file = true,
            folder = true,
            git = true,
          },
        },
      },
    })

    dim_gitignored_highlights()
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = dim_gitignored_highlights,
    })
  end,
}
