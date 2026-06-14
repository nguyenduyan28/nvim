return {
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        current_line_blame = true,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol",
          delay = 500,
        },
        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
        on_attach = function(bufnr)
          local gitsigns = require("gitsigns")
          local function map(keys, fn, desc)
            vim.keymap.set("n", keys, fn, { buffer = bufnr, desc = desc })
          end

          map("]h", function() gitsigns.nav_hunk("next") end, "Next git hunk")
          map("[h", function() gitsigns.nav_hunk("prev") end, "Previous git hunk")
          map("<leader>gb", gitsigns.blame_line, "Git blame line")
          map("<leader>gB", gitsigns.toggle_current_line_blame, "Toggle git blame")
          map("<leader>gp", gitsigns.preview_hunk, "Preview git hunk")
          map("<leader>gs", gitsigns.stage_hunk, "Stage git hunk")
          map("<leader>gr", gitsigns.reset_hunk, "Reset git hunk")
        end,
      })
    end,
  },

  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },

  -- VSCode-like Source Control: file list + side-by-side diff + staging
  {
    "sindrets/diffview.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFileHistory" },
    config = function()
      require("diffview").setup({
        enhanced_diff_hl = true,
        view = {
          -- side-by-side (2 split) layout like VSCode
          default = { layout = "diff2_horizontal" },
          merge_tool = { layout = "diff3_horizontal" },
        },
      })
    end,
  },
}
