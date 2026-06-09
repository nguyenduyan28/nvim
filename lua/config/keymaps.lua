local map = vim.keymap.set

-- Save (Cmd+S)
map({ "n", "i" }, "<D-s>", "<cmd>w<cr>", { desc = "Save file" })

-- File search like VSCode Cmd+P (works in normal, insert, visual)
map({ "n", "i", "v" }, "<D-p>", "<cmd>Telescope find_files<cr>", { desc = "Find files" })

-- Command palette like VSCode Cmd+Shift+P
map({ "n", "i", "v" }, "<D-S-p>", "<cmd>Telescope commands<cr>", { desc = "Command palette" })

-- Search text in project like VSCode Cmd+Shift+F (works in normal, insert, visual)
map({ "n", "i", "v" }, "<D-S-f>", "<cmd>Telescope live_grep<cr>", { desc = "Search in project" })
map("n", "<leader>f", "<cmd>Telescope live_grep<cr>", { desc = "Search in project" })

-- Search text in current file like VSCode Cmd+F (works in normal, insert, visual)
map({ "n", "i", "v" }, "<D-f>", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Search in file" })

-- Go to Symbol in file like VSCode Cmd+Shift+O
map({ "n", "i", "v" }, "<D-S-o>", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Symbols in file" })

-- Go to Symbol in project like VSCode Cmd+T
map({ "n", "i", "v" }, "<D-t>", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", { desc = "Symbols in project" })

-- Open buffers
map("n", "<leader>b", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })

-- Toggle file tree like VSCode Cmd+B (works in normal, insert, visual)
map({ "n", "i", "v" }, "<D-b>", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle file tree" })

-- Focus file tree
map("n", "<leader>e", "<cmd>NvimTreeFocus<cr>", { desc = "Focus file tree" })

-- Navigate between windows (tree <-> editor <-> splits)
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Git panel
map("n", "<leader>g", "<cmd>LazyGit<cr>", { desc = "Open LazyGit" })

-- Is the Diffview tab currently open? (without force-loading the plugin)
local function diffview_is_open()
  if not package.loaded["diffview"] then
    return false
  end
  return require("diffview.lib").get_current_view() ~= nil
end

-- VSCode-like Source Control: toggle changed-files list + side-by-side diff (Cmd+Shift+G)
map({ "n", "i", "v" }, "<D-S-g>", function()
  if diffview_is_open() then
    vim.cmd("DiffviewClose")
  else
    vim.cmd("DiffviewOpen")
  end
end, { desc = "Toggle source control (diff view)" })
map("n", "<leader>gq", "<cmd>DiffviewClose<cr>", { desc = "Close diff view" })
map("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "File history (current file)" })
map("n", "<leader>gH", "<cmd>DiffviewFileHistory<cr>", { desc = "File history (project)" })

-- Go back / forward like VSCode
map("n", "<A-Left>", "<C-o>", { desc = "Go back" })
map("n", "<A-Right>", "<C-i>", { desc = "Go forward" })

-- Close buffer
map("n", "<leader>w", "<cmd>bdelete<cr>", { desc = "Close buffer" })

-- Close current tab/view like VSCode Cmd+W:
-- Diffview tab -> close it cleanly; multiple tabs -> close tab; otherwise close buffer
map({ "n", "i", "v" }, "<D-w>", function()
  if diffview_is_open() then
    vim.cmd("DiffviewClose")
  elseif #vim.api.nvim_list_tabpages() > 1 then
    vim.cmd("tabclose")
  else
    vim.cmd("bdelete")
  end
end, { desc = "Close tab / view / buffer" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search" })

-- Font zoom like VSCode (Neovide): Cmd+= bigger, Cmd+- smaller, Cmd+0 reset
if vim.g.neovide then
  local function scale(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end
  map({ "n", "i", "v" }, "<D-=>", function() scale(1.1) end, { desc = "Zoom in" })
  map({ "n", "i", "v" }, "<D-->", function() scale(1 / 1.1) end, { desc = "Zoom out" })
  map({ "n", "i", "v" }, "<D-0>", function() vim.g.neovide_scale_factor = 1 end, { desc = "Reset zoom" })
end