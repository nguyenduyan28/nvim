return {
  "okuuva/auto-save.nvim",
  version = "^1", -- pin to v1.* to avoid breaking changes
  event = { "InsertLeave", "TextChanged" },
  opts = {
    enabled = true,
    trigger_events = {
      immediate_save = { "BufLeave", "FocusLost" }, -- save right away
      defer_save = { "InsertLeave", "TextChanged" }, -- save after debounce
    },
    -- only save real, modifiable, writable files
    condition = function(buf)
      if vim.fn.getbufvar(buf, "&modifiable") ~= 1 then
        return false
      end
      if vim.bo[buf].buftype ~= "" then
        return false
      end
      return true
    end,
    write_all_buffers = false,
    debounce_delay = 1000,
  },
}
