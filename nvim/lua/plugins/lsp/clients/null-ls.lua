local null_ls = require("null-ls")

local with_root_file = function(...)
  local files = { ... }
  return function(utils)
    return utils.root_has_file(files)
  end
end

local M = {}

M.setup = function(on_attach, capabilities)
  null_ls.setup({
    debug = true,
    capabilities = capabilities,
    on_attach = on_attach,
    sources = {
      null_ls.builtins.diagnostics.rubocop.with({
        condition = with_root_file(".rubocop.yml"),
        command = "bundle",
        args = { "exec", "rubocop", "-f", "json", "--stdin", "$FILENAME" },
      }),
      null_ls.builtins.formatting.trim_whitespace.with({
        filetypes = { "tmux", "zsh" },
      }),
      null_ls.builtins.formatting.rubocop.with({
        condition = with_root_file(".rubocop.yml"),
        command = "bundle",
        args = { "exec", "rubocop", "--auto-correct", "-f", "quiet", "--stderr", "--stdin", "$FILENAME" },
      }),
    }
  })
end

return M
