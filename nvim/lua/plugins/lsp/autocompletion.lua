-- Completions explained here:
-- https://www.youtube.com/watch?v=_DnmphIwnjo
local M = {}

M.setup = function()
  local lspkind = require("lspkind")
  local luasnip = require("luasnip")
  local cmp = require("cmp")

  require("luasnip/loaders/from_vscode").lazy_load()

  -- Don't show the dumb matching stuff.
  -- Get rid of extra messages when using completion.
  vim.opt.shortmess:append("c")
  vim.opt.completeopt = { "menu", "menuone", "noselect" }
  cmp.setup({
    mapping = {
      -- Select the [n]ext item
      ["<C-n>"] = cmp.mapping.select_next_item(),

      -- Select the [p]revious item
      ["<C-p>"] = cmp.mapping.select_prev_item(),

      -- Accept completion
      ["<C-y>"] = cmp.mapping.confirm({ select = true }),

      -- TAB: Prioritize Copilot over LSP completion
      ["<Tab>"] = cmp.mapping(function(fallback)
        local copilot_suggestion = require("copilot.suggestion")
        if copilot_suggestion.is_visible() then
          copilot_suggestion.accept()
        elseif cmp.visible() then
          cmp.confirm({ select = true })
        else
          fallback()
        end
      end, { "i", "s" }),

      -- Docs
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),

      -- Discard completion
      ["<C-e>"] = cmp.mapping.close(),
    },
    sources = {
      { name = "nvim_lua" },
      { name = "nvim_lsp", keyword_length = 3 },
      { name = "luasnip",  keyword_length = 3 },
      { name = "buffer",   keyword_length = 5 },
      { name = "path" },
    },
    formatting = {
      format = lspkind.cmp_format({
        with_text = true,
        menu = {
          nvim_lsp = "[LSP]",
          nvim_lua = "[NVIM_LUA]",
          luasnip = "[Snippet]",
          buffer = "[Buffer]",
          path = "[Path]",
        },
      }),
    },
    sorting = {
      comparators = {
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.score,
        function(entry1, entry2)
          local _, entry1_under = entry1.completion_item.label:find("^_+")
          local _, entry2_under = entry2.completion_item.label:find("^_+")
          entry1_under = entry1_under or 0
          entry2_under = entry2_under or 0
          if entry1_under > entry2_under then
            return false
          elseif entry1_under < entry2_under then
            return true
          end
        end,
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    },
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    experimental = {
      ghost_text = false,
      native_menu = false,
    },
    enabled = function()
      -- Enable plugin for nvim-dap completions on REPL panel
      return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
    end,
  })

  -- Add vim-dadbod-completion in sql files
  vim.cmd([[
    augroup DadbodSql
    au!
    autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer { sources = { { name = 'vim-dadbod-completion' } } }
    augroup END
  ]])
end

return M
