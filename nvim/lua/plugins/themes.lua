--- Theme management
--- `<leader>uC`  pick & preview installed themes
--- `<leader>tl`  toggle light/dark mode of the current theme
--- `<leader>tt`  cycle through available themes

local DEFAULT_THEME_DARK = "catppuccin"
local DEFAULT_THEME_LIGHT = "flexoki"
local DEFAULT_THEME_MODE = "dark"

local CODE_HOME = vim.fn.expand("~/code/")

local FUN_DIRS = {
  "opensource/gleam-learning",
}

local THEMES = {
  { name = "catppuccin", background = "dark" },
  {
    name = "evergarden",
    background = "dark",
    before = function()
      require("evergarden").setup({ theme = { variant = "winter", accent = "pink" } })
    end,
  },
}

local current_theme_index = 1

local function apply_theme(entry)
  if entry.before then entry.before() end
  vim.o.background = entry.background
  vim.cmd("colorscheme " .. entry.name)
end

local function toggle_light()
  if vim.o.background == "dark" then
    vim.o.background = "light"
    vim.cmd("colorscheme " .. DEFAULT_THEME_LIGHT)
  else
    vim.o.background = "dark"
    vim.cmd("colorscheme " .. DEFAULT_THEME_DARK)
  end
end

local function cycle_theme()
  current_theme_index = (current_theme_index % #THEMES) + 1
  local entry = THEMES[current_theme_index]
  apply_theme(entry)
  Snacks.notify(entry.name, { title = "Theme" })
end

local function is_fun_dir()
  local cwd = vim.fn.getcwd()
  for _, dir in ipairs(FUN_DIRS) do
    if cwd:find(CODE_HOME .. dir, 1, true) == 1 then return true end
  end
end

local function apply_dir_theme()
  local entry = vim.iter(THEMES):find(function(t)
    return t.name == (is_fun_dir() and "evergarden" or DEFAULT_THEME_DARK)
  end)
  if entry then apply_theme(entry) end
end

local function init_theme()
  vim.o.background = DEFAULT_THEME_MODE
  local theme = DEFAULT_THEME_MODE == "dark" and DEFAULT_THEME_DARK or DEFAULT_THEME_LIGHT
  vim.cmd("colorscheme " .. theme)
  vim.keymap.set("n", "<leader>tl", toggle_light, { desc = "Toggle light/dark mode" })
  vim.keymap.set("n", "<leader>tt", cycle_theme, { desc = "Cycle themes" })

  vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
    callback = apply_dir_theme,
  })
end

return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    config = init_theme,
  },
  { "kepano/flexoki-neovim", name = "flexoki" },
  {
    "everviolet/nvim",
    name = "evergarden",
    opts = {
      theme = {
        variant = "winter", -- 'winter'|'fall'|'spring'|'summer'
        accent = "pink", -- red|orange|yellow|green|blue|purple|pink|aqua
      },
      editor = {
        transparent_background = false,
        sign = { color = "none" },
        float = {
          color = "mantle",
          solid_border = false,
        },
        completion = {
          color = "surface0",
        },
      },
    },
  },
}
