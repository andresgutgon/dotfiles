M = {}

local my_themes = { 
  "nord", 
  "catppuccin", 
  "gruvbox",
  "darkplus", 
  "vscode",
  "dracula"
}

local function starts_with(name, name_list)
    for _, prefix in ipairs(name_list) do
        if string.find(name, "^" .. prefix) then
            return true
        end
    end
    return false
end

local function init_themes ()
  local all_themes = vim.fn.getcompletion('', 'color')
  local subset = {}

  for _, scheme in ipairs(all_themes) do
    if starts_with(scheme, my_themes) then
      table.insert(subset, scheme)
    end
  end

  return subset
end

local colorschemes = init_themes()

function M.colorscheme_picker()
    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')
    local conf = require('telescope.config').values

    pickers.new({}, {
        prompt_title = 'Colorschemes',
        finder = finders.new_table {
            results = colorschemes,
        },
        sorter = conf.generic_sorter({}),
        attach_mappings = function(_, map)
            map('i', '<CR>', function(bufnr)
                local selection = action_state.get_selected_entry()
                actions.close(bufnr)
                vim.cmd('colorscheme ' .. selection[1])
            end)
            return true
        end,
    }):find()
end


return M
