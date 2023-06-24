local ok_virtual_text, virtual_text = pcall(require, "nvim-dap-virtual-text")

if not (ok_virtual_text) then
  return
end

virtual_text.setup({
  enabled = true,
  enabled_commands = true,
  highlight_changed_variables = true,
  highlight_new_as_changed = false,
  show_stop_reason = true,
  commented = false,
  only_first_definition = true,
  all_references = false,
  clear_on_continue = false,
  display_callback = function(variable, _, _, _, options)
    if options.virt_text_pos == 'inline' then
      return ' = ' .. variable.value
    else
      return variable.name .. ' = ' .. variable.value
    end
  end,
  -- TODO: Use when in 0.10 version of NVim
  --[[ virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol', ]]
})
