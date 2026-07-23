return {
  -- Mason: installs and manages LSP server binaries
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    config = function()
      require("mason").setup()
    end,
  },

  -- Bridge between Mason and nvim-lspconfig (auto-installs + enables servers)
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
      "ray-x/lsp_signature.nvim",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")
      local vue_language_server_path = vim.fn.stdpath("data")
        .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

      vim.lsp.config("vtsls", {
        filetypes = {
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "vue",
        },
        settings = {
          vtsls = {
            tsserver = {
              globalPlugins = {
                {
                  name = "@vue/typescript-plugin",
                  location = vue_language_server_path,
                  languages = { "vue" },
                  configNamespace = "typescript",
                },
              },
            },
          },
        },
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })

      lspconfig.util.default_config.capabilities = vim.tbl_deep_extend(
        "force",
        lspconfig.util.default_config.capabilities,
        capabilities
      )

      require("mason-lspconfig").setup({
        ensure_installed = {
          "vue_ls",
          "vtsls",
          "eslint",
          "lua_ls",
          "ruby_lsp",
          "rust_analyzer",
        },
        automatic_enable = {
          "vue_ls",
          "vtsls",
          "eslint",
          "lua_ls",
          "ruby_lsp",
          "rust_analyzer",
        },
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
          local sysname = (vim.uv or vim.loop).os_uname().sysname
          local primary_mod = sysname == "Darwin" and "D" or "C"
          local function map(keys, fn, desc)
            vim.keymap.set("n", keys, fn, { buffer = buf, desc = desc })
          end

          map("gd", vim.lsp.buf.definition, "Go to definition")
          -- Cmd/Ctrl+Click jumps to definition like VSCode (moves cursor to click, then jumps)
          vim.keymap.set("n", ("<%s-LeftMouse>"):format(primary_mod), "<LeftMouse><cmd>lua vim.lsp.buf.definition()<cr>",
            { buffer = buf, desc = "Go to definition (click)" })
          map("gD", vim.lsp.buf.declaration, "Go to declaration")
          map("gi", vim.lsp.buf.implementation, "Go to implementation")
          map("gr", vim.lsp.buf.references, "References")
          map("K", vim.lsp.buf.hover, "Hover docs")
          vim.keymap.set({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, { buffer = buf, desc = "Signature help" })
          if not vim.b[buf].lsp_signature_attached then
            require("lsp_signature").on_attach({
              bind = true,
              floating_window = true,
              hint_enable = false,
              handler_opts = {
                border = "rounded",
              },
            }, buf)
            vim.b[buf].lsp_signature_attached = true
          end
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
