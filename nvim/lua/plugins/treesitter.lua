return {
  { "jwalton512/vim-blade" },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
    },
    config = function()
      local ensure = {
        "astro",
        "lua",
        "ruby",
        "elixir",
        "eex",
        "heex",
        "php",
        "css",
        "gitignore",
        "gleam",
        "http",
        "rust",
        "vimdoc",
        "sql",
        "javascript",
        "typescript",
        "tsx",
        "python",
        "svelte",
        "markdown",
        "markdown_inline",
        "blade",
      }

      -- Custom Blade parser (must be registered via User TSUpdate)
      vim.api.nvim_create_autocmd("User", {
        pattern = "TSUpdate",
        callback = function()
          require("nvim-treesitter.parsers").blade = {
            install_info = {
              url = "https://github.com/EmranMR/tree-sitter-blade",
              branch = "main",
              generate = true,
              queries = "queries",
            },
          }
        end,
      })

      -- MDX -> markdown
      vim.filetype.add({ extension = { mdx = "mdx" } })
      vim.treesitter.language.register("markdown", "mdx")
      -- Blade filetype mapping for *.blade.php
      vim.filetype.add({ pattern = { [".*%.blade%.php"] = "blade" } })

      require("nvim-treesitter").install(ensure)

      -- Enable highlight + indent per buffer
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
          if not lang then return end
          if not pcall(vim.treesitter.start, ev.buf, lang) then return end
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })

      -- Textobjects (main branch: explicit keymaps, no `keymaps = {...}` config table)
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")
      local swap = require("nvim-treesitter-textobjects.swap")

      local function sel(q)
        return function() select.select_textobject(q, "textobjects") end
      end
      local function mv_ns(q)
        return function() move.goto_next_start(q, "textobjects") end
      end
      local function mv_ne(q)
        return function() move.goto_next_end(q, "textobjects") end
      end
      local function mv_ps(q)
        return function() move.goto_previous_start(q, "textobjects") end
      end
      local function mv_pe(q)
        return function() move.goto_previous_end(q, "textobjects") end
      end

      local xo = { "x", "o" }
      local nxo = { "n", "x", "o" }

      -- select
      vim.keymap.set(xo, "af", sel("@function.outer"))
      vim.keymap.set(xo, "if", sel("@function.inner"))
      vim.keymap.set(xo, "ac", sel("@class.outer"))
      vim.keymap.set(xo, "ic", sel("@class.inner"))
      vim.keymap.set(xo, "aa", sel("@parameter.outer"))
      vim.keymap.set(xo, "ia", sel("@parameter.inner"))
      vim.keymap.set(xo, "ab", sel("@block.outer"))
      vim.keymap.set(xo, "ib", sel("@block.inner"))

      -- move
      vim.keymap.set(nxo, "]f", mv_ns("@function.outer"))
      vim.keymap.set(nxo, "]c", mv_ns("@class.outer"))
      vim.keymap.set(nxo, "]a", mv_ns("@parameter.inner"))
      vim.keymap.set(nxo, "]F", mv_ne("@function.outer"))
      vim.keymap.set(nxo, "]C", mv_ne("@class.outer"))
      vim.keymap.set(nxo, "]A", mv_ne("@parameter.inner"))
      vim.keymap.set(nxo, "[f", mv_ps("@function.outer"))
      vim.keymap.set(nxo, "[c", mv_ps("@class.outer"))
      vim.keymap.set(nxo, "[a", mv_ps("@parameter.inner"))
      vim.keymap.set(nxo, "[F", mv_pe("@function.outer"))
      vim.keymap.set(nxo, "[C", mv_pe("@class.outer"))
      vim.keymap.set(nxo, "[A", mv_pe("@parameter.inner"))

      -- swap
      vim.keymap.set("n", "<leader>sn", function() swap.swap_next("@parameter.inner") end)
      vim.keymap.set("n", "<leader>sp", function() swap.swap_previous("@parameter.inner") end)
    end,
  },
}
