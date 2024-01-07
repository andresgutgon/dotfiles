-- Completions explained here:
-- https://www.youtube.com/watch?v=_DnmphIwnjo

local M = {}

local check_backspace = function()
  local col = vim.fn.col "." - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

M.setup = function()
  local lspkind = require("lspkind")

  local luasnip = require("luasnip")
  local cmp = require("cmp")

  require("luasnip/loaders/from_vscode").lazy_load()

  -- Don't show the dumb matching stuff.
  vim.opt.shortmess:append "c"
  vim.opt.completeopt = { "menu", "menuone", "noselect" }

  -- Complextras.nvim configuration
  vim.api.nvim_set_keymap(
    "i",
    "<C-x><C-m>",
    [[<c-r>=luaeval("require('complextras').complete_matching_line()")<CR>]],
    { noremap = true }
  )

  vim.api.nvim_set_keymap(
    "i",
    "<C-x><C-d>",
    [[<c-r>=luaeval("require('complextras').complete_line_from_cwd()")<CR>]],
    { noremap = true }
  )

  cmp.setup({
    mapping = {
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-e>"] = cmp.mapping.close(),
      ["<c-y>"] = cmp.mapping(
        cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        },
        { "i", "c" }
      ),
      ["<c-space>"] = cmp.mapping {
        i = cmp.mapping.complete(),
        c = function(
          _ --[[fallback]]
        )
          if cmp.visible() then
            if not cmp.confirm { select = true } then
              return
            end
          else
            cmp.complete()
          end
        end,
      },
      ["<CR>"] = cmp.mapping.confirm { select = true },
      -- Super tab
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expandable() then
          luasnip.expand()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif check_backspace() then
          fallback()
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
      ["<c-q>"] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
    },
    sources = {
      { name = "nvim_lua" },
      { name = "nvim_lsp", keyword_length = 3 },
      { name = "luasnip",  keyword_length = 3 },
      { name = "buffer",   keyword_length = 5 },
      { name = "path" },
    },
    formatting = {
      format = lspkind.cmp_format {
        with_text = true,
        menu = {
          nvim_lsp = "[LSP]",
          nvim_lua = "[NVIM_LUA]",
          luasnip = "[Snippet]",
          buffer = "[Buffer]",
          path = "[Path]",
        },
      },
    },
    sorting = {
      comparators = {
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.score,
        function(entry1, entry2)
          local _, entry1_under = entry1.completion_item.label:find "^_+"
          local _, entry2_under = entry2.completion_item.label:find "^_+"
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
      return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
          or require("cmp_dap").is_dap_buffer()
    end
  })

  -- Add vim-dadbod-completion in sql files
  vim.cmd [[
    augroup DadbodSql
      au!
      autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer { sources = { { name = 'vim-dadbod-completion' } } }
    augroup END
  ]]
end

return M
