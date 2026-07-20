local map = vim.keymap.set
local sysname = (vim.uv or vim.loop).os_uname().sysname
local primary_mod = sysname == "Darwin" and "D" or "C"

local function primary_key(key)
  return ("<%s-%s>"):format(primary_mod, key)
end

local function project_root()
  return vim.fs.root(0, ".git") or (vim.uv or vim.loop).cwd()
end

local function find_project_files()
  local builtin = require("telescope.builtin")
  local root = project_root()

  if vim.uv.fs_stat(root .. "/.git") then
    builtin.git_files({ cwd = root, show_untracked = true })
  else
    builtin.find_files({ cwd = root })
  end
end

local function grep_project()
  require("telescope.builtin").live_grep({ cwd = project_root() })
end

-- Save like VSCode: Cmd on macOS, Ctrl on Linux/Windows.
map({ "n", "i" }, primary_key("s"), "<cmd>w<cr>", { desc = "Save file" })

-- Toggle comments for the current line or visual selection.
map("n", primary_key("/"), "gcc", { remap = true, desc = "Toggle comment" })
map("x", primary_key("/"), "gc", { remap = true, desc = "Toggle comment selection" })

-- Clipboard: Cmd/Ctrl+C copy, Cmd/Ctrl+V paste, Cmd/Ctrl+X cut
map("v", primary_key("c"), '"+y', { desc = "Copy" })
map("n", primary_key("v"), '"+p', { desc = "Paste" })
map("i", primary_key("v"), "<C-r>+", { desc = "Paste" })
map("v", primary_key("v"), '"_d"+P', { desc = "Paste over selection" })
map("v", primary_key("x"), '"+d', { desc = "Cut" })

-- New tab like browser
map({ "n", "i" }, primary_key("n"), "<cmd>tabnew<cr>", { desc = "New tab" })

-- File search like VSCode Cmd/Ctrl+P (works in normal, insert, visual)
map({ "n", "i", "v" }, primary_key("p"), find_project_files, { desc = "Find files" })

-- Command palette like VSCode Cmd/Ctrl+Shift+P
map({ "n", "i", "v" }, primary_key("S-p"), "<cmd>Telescope commands<cr>", { desc = "Command palette" })

-- Search text in project like VSCode Cmd/Ctrl+Shift+F (works in normal, insert, visual)
map({ "n", "i", "v" }, primary_key("S-f"), grep_project, { desc = "Search in project" })
map("n", "<leader>f", grep_project, { desc = "Search in project" })

-- Search text in current file like VSCode Cmd/Ctrl+F (works in normal, insert, visual)
map({ "n", "i", "v" }, primary_key("f"), "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Search in file" })

-- Go to Symbol in file like VSCode Cmd/Ctrl+Shift+O
map({ "n", "i", "v" }, primary_key("S-o"), "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Symbols in file" })

-- Go to Symbol in project like VSCode Cmd/Ctrl+T
map({ "n", "i", "v" }, primary_key("t"), "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", { desc = "Symbols in project" })

-- Toggle rendered Markdown preview like VSCode Cmd+Shift+V.
map({ "n", "i", "v" }, "<D-S-v>", "<cmd>RenderMarkdown toggle<cr>", { desc = "Toggle Markdown preview" })

-- Open buffers
map("n", "<leader>b", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
map({ "n", "i", "v" }, primary_key("S-]"), "<cmd>bnext<cr>", { desc = "Next buffer" })
map({ "n", "i", "v" }, primary_key("S-["), "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "L", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "H", "<cmd>bprevious<cr>", { desc = "Previous buffer" })

-- Toggle file tree like VSCode Cmd/Ctrl+B (works in normal, insert, visual)
map({ "n", "i", "v" }, primary_key("b"), "<cmd>NvimTreeToggle<cr>", { desc = "Toggle file tree" })

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

local function diffview_is_opening()
  if not package.loaded["diffview"] then
    return false
  end
  return #require("diffview.lib").views > 0
end

-- VSCode-like Source Control: toggle changed-files list + side-by-side diff (Cmd/Ctrl+Shift+G)
map({ "n", "i", "v" }, primary_key("S-g"), function()
  if diffview_is_open() then
    vim.cmd("DiffviewClose")
  elseif not diffview_is_opening() then
    vim.cmd("DiffviewOpen")
  end
end, { desc = "Toggle source control (diff view)" })
map("n", "<leader>gq", "<cmd>DiffviewClose<cr>", { desc = "Close diff view" })
map("n", "<leader>gm", function()
  if diffview_is_open() then
    vim.cmd("DiffviewClose")
  else
    vim.cmd("DiffviewOpen master...HEAD")
  end
end, { desc = "Compare branch with master" })
map("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "File history (current file)" })
map("n", "<leader>gH", "<cmd>DiffviewFileHistory<cr>", { desc = "File history (project)" })

-- Go back / forward like VSCode
map("n", "<A-Left>", "<C-o>", { desc = "Go back" })
map("n", "<A-Right>", "<C-i>", { desc = "Go forward" })

-- Close buffer
map("n", "<leader>w", "<cmd>bdelete<cr>", { desc = "Close buffer" })

-- Close current tab/view like VSCode Cmd/Ctrl+W:
-- Diffview tab -> close it cleanly; multiple tabs -> close tab; otherwise close buffer
map({ "n", "i", "v" }, primary_key("w"), function()
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

-- Font zoom like VSCode (Neovide): Cmd/Ctrl+= bigger, Cmd/Ctrl+- smaller, Cmd/Ctrl+0 reset
if vim.g.neovide then
  local function scale(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end
  map({ "n", "i", "v" }, primary_key("="), function() scale(1.1) end, { desc = "Zoom in" })
  map({ "n", "i", "v" }, primary_key("-"), function() scale(1 / 1.1) end, { desc = "Zoom out" })
  map({ "n", "i", "v" }, primary_key("0"), function() vim.g.neovide_scale_factor = 1 end, { desc = "Reset zoom" })
end
