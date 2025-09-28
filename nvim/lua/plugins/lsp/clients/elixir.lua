local M = {}
local lspconfig = require("lspconfig")

M.setup = function(_, capabilities)
  lspconfig.elixirls.setup({
    capabilities = capabilities,
    cmd = { vim.fn.expand("~/.local/bin/expert") },
    root_dir = function(fname)
      local util = require("lspconfig.util")
      -- Find nearest mix.exs upwards
      local mix_root = util.root_pattern("mix.exs")(fname)
      if mix_root then
        return mix_root
      end

      -- If opened from repo root with no mix.exs, try to detect packages
      local git_root = util.root_pattern(".git")(fname)
      if git_root then
        local package_mix = util.path.join(git_root, "packages", "*", "mix.exs")
        local matches = vim.fn.glob(package_mix, false, true)
        if #matches > 0 then
          return util.path.dirname(matches[1]) -- pick the first package
        end
      end

      return git_root or vim.fn.getcwd()
    end,

    flags = {
      debounce_text_changes = 150,
    },
  })
end

return M
