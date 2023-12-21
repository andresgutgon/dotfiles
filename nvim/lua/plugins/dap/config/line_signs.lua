-- VSCode theme visual line selection color
local theme_line_color = '#264F78'
vim.api.nvim_set_hl(0, 'DapLine', { ctermbg = 0, fg = nil, bg = theme_line_color })
vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#993939', bg = theme_line_color })
vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef', bg = theme_line_color })
vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379', bg = theme_line_color })


-- # Line Signs
vim.fn.sign_define(
  'DapBreakpoint',
  {
    text = "●",
    texthl = 'DapBreakpoint',
    linehl = 'DapLine',
    numhl = 'DapLine'
  }
)
vim.fn.sign_define(
  'DapBreakpointCondition',
  {
    text = " ●",
    texthl = 'DapBreakpoint',
    linehl = 'DapLine',
    numhl = 'DapLine'
  }
)

vim.fn.sign_define(
  'DapBreakpointRejected',
  {
    text = ' ',
    texthl = 'DapBreakpoint',
    linehl = 'DapLine',
    numhl = 'DapLine'
  }
)

vim.fn.sign_define(
  'DapLogPoint',
  {
    text = ' ',
    texthl = 'DapLogPoint',
    linehl = 'DapLine',
    numhl = 'DapLine'
  }
)
vim.fn.sign_define(
  'DapStopped',
  {
    text = " ",
    texthl = 'DapStopped',
    linehl = 'DapLine',
    numhl = 'DapLine'
  }
)
