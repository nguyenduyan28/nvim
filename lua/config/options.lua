vim.g.mapleader = " "

vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.termguicolors = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.wrap = true
vim.opt.linebreak = true

vim.opt.clipboard = "unnamedplus"
vim.opt.signcolumn = "yes"

vim.opt.splitright = true
vim.opt.splitbelow = true

-- GUI font (Neovide / other GUIs). The :h<N> sets the point size.
vim.opt.guifont = "JetBrains Mono:h16"

-- Neovide GUI: disable all animations (only applies when running in Neovide)
if vim.g.neovide then
  vim.g.neovide_scale_factor = 1.0
  vim.g.neovide_position_animation_length = 0
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_cursor_trail_size = 0
  vim.g.neovide_cursor_animate_in_insert_mode = false
  vim.g.neovide_cursor_animate_command_line = false
  vim.g.neovide_scroll_animation_length = 0
  vim.g.neovide_scroll_animation_far_lines = 0
  vim.g.neovide_cursor_vfx_mode = ""
end