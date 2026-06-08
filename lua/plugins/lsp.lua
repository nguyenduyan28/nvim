return {
  -- Mason: installs and manages LSP server binaries
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  -- Bridge between Mason and nvim-lspconfig (auto-installs + enables servers)
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason-lspconfig").setup({
        -- TypeScript / JavaScript language server
        ensure_installed = { "vtsls" },
        automatic_installation = true,
      })

      -- Show diagnostics inline
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
      })

      -- LSP keymaps, set per-buffer when a server attaches
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local buf = args.buf
          local function map(keys, fn, desc)
            vim.keymap.set("n", keys, fn, { buffer = buf, desc = desc })
          end

          map("gd", vim.lsp.buf.definition, "Go to definition")
          -- Cmd+Click jumps to definition like VSCode (moves cursor to click, then jumps)
          vim.keymap.set("n", "<D-LeftMouse>", "<LeftMouse><cmd>lua vim.lsp.buf.definition()<cr>",
            { buffer = buf, desc = "Go to definition (click)" })
          map("gD", vim.lsp.buf.declaration, "Go to declaration")
          map("gi", vim.lsp.buf.implementation, "Go to implementation")
          map("gr", vim.lsp.buf.references, "References")
          map("K", vim.lsp.buf.hover, "Hover docs")
          map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("<leader>d", vim.diagnostic.open_float, "Show diagnostic")
          map("[d", function() vim.diagnostic.jump({ count = -1 }) end, "Prev diagnostic")
          map("]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")
        end,
      })
    end,
  },
}
