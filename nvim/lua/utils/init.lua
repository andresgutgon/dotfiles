local api = vim.api
local M = {}

local env_vars = {}

local function get_script_dir()
  local str = debug.getinfo(2, "S").source:sub(2)
  return str:match("(.*/)") or "./"
end

local function parse_env_file(path)
  local file = io.open(path, "r")

  if not file then
    print("No .env file found. Put one in nvim/lua/utils/.env")
    return env_vars
  end

  for line in file:lines() do
    if line:match("%S") and not line:match("^#") then
      local key, value = line:match("([^=]+)=(.*)")
      env_vars[key] = value
    end
  end

  file:close()
  return env_vars
end

local get_map_options = function(custom_options)
  local options = { noremap = true, silent = true }
  if custom_options then
    options = vim.tbl_extend("force", options, custom_options)
  end
  return options
end

M.define_augroups = function(definitions)
  for group_name, definition in pairs(definitions) do
    vim.cmd("augroup " .. group_name)
    vim.cmd("autocmd!")

    for _, def in pairs(definition) do
      local command = table.concat(vim.tbl_flatten({ "autocmd", def }), " ")
      vim.cmd(command)
    end

    vim.cmd("augroup END")
  end
end

M.file_exists = function(path)
  local file = io.open(path, "r")
  if file then
    file:close()
    return true
  else
    return false
  end
end

M.command = function(name, fn)
  vim.cmd(string.format("command! %s %s", name, fn))
end

M.lua_command = function(name, fn)
  M.command(name, "lua " .. fn)
end

M.buf_map = function(bufnr, mode, target, source, opts)
  api.nvim_buf_set_keymap(bufnr or 0, mode, target, source, get_map_options(opts))
end

M.table = {
  some = function(tbl, cb)
    for k, v in pairs(tbl) do
      if cb(k, v) then
        return true
      end
    end
    return false
  end,
}

M.merge = function(original, new)
  for key, value in pairs(new) do
    if type(value) == "table" and type(original[key]) == "table" then
      M.merge(original[key], value)
    else
      original[key] = value
    end
  end
end

M.load_env_file = function()
  if next(env_vars) ~= nil then -- Checks if env_vars is not empty
    return env_vars
  else
    local current_dir = get_script_dir()
    local path = current_dir .. ".env"
    return parse_env_file(path)
  end
end

return M
