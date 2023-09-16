-- Pint:
-- Laravel Pint is an opinionated PHP code style fixer for minimalists.
-- Pint is built on top of PHP-CS-Fixer and makes it simple to ensure that
-- your code style stays clean and consistent.
-- https://laravel.com/docs/10.x/pint
function Pint()
  local current_file = vim.fn.expand("%:p")
  local project_root = vim.fn.getcwd() -- Get the current working directory
  local pint = project_root .. "/vendor/bin/pint " .. current_file
  vim.fn.system(pint)

  -- HACK: Refresh current buffer to reflect the changes
  vim.api.nvim_command('checktime')
end

-- Automatically run php_cs_fixer() after saving *.php files
vim.cmd([[ autocmd BufWritePost *.php lua Pint() ]])
