local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
end

local progress = function()
  local current_line = vim.fn.line(".")
  local total_lines = vim.fn.line("$")
  local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
  local line_ratio = current_line / total_lines
  local index = math.ceil(line_ratio * #chars)
  return chars[index]
end

local spaces = function()
  return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { "error", "warn" },
  symbols = { error = " ", warn = " " },
  colored = false,
  update_in_insert = false,
  always_visible = true,
}

local diff = {
  "diff",
  colored = false,
  symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
  cond = hide_in_width,
}

local mode = {
  "mode",
  fmt = function(str)
    return "-- " .. str .. " --"
  end,
}

local filetype = {
  "filetype",
  icons_enabled = false,
  icon = nil,
}

local branch = {
  "branch",
  icons_enabled = true,
  icon = "",
}

local location = {
  "location",
  padding = 0,
}

-- Sidekick/Copilot status
local sidekick_status = {
  function()
    return " Copilot"
  end,
  color = function()
    local ok, sidekick = pcall(require, "sidekick.status")
    if not ok then
      return { fg = "#89b4fa", bg = "#313244", gui = "bold" }
    end
    local status = sidekick.get()
    if status then
      if status.kind == "Error" then
        return { fg = "#f38ba8", bg = "#313244", gui = "bold" }
      elseif status.busy then
        return { fg = "#f9e2af", bg = "#313244", gui = "bold" }
      else
        return { fg = "#a6e3a1", bg = "#313244", gui = "bold" }
      end
    end
    return { fg = "#89b4fa", bg = "#313244", gui = "bold" }
  end,
}

local M = {}

function M.setup()
  -- stylua: ignore
  require("lualine").setup({
    options = {
      theme = 'catppuccin',
      icons_enabled = true,
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
      always_divide_middle = true,
    },
    sections = {
      lualine_a = { branch, diagnostics },
      lualine_b = { mode },
      lualine_c = { sidekick_status },
      -- lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_x = { diff, spaces, "encoding", filetype },
      lualine_y = { location },
      lualine_z = { progress },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "filename" },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {},
    extensions = {},
  })
end

return M
