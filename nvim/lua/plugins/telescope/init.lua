return {
  "nvim-telescope/telescope.nvim",
  branch = "master",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { -- If encountering errors, see telescope-fzf-native README for install instructions
      "nvim-telescope/telescope-fzf-native.nvim",

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = "make",

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
    {
      "nvim-telescope/telescope-ui-select.nvim",
      config = function()
        require("telescope").setup({
          extensions = {
            ["ui-select"] = {
              require("telescope.themes").get_dropdown({}),
            },
          },
        })
        require("telescope").load_extension("ui-select")
      end,
    },
  },
  config = function()
    -- Telescope is a fuzzy finder that comes with a lot of different things that
    -- it can fuzzy find! It's more than just a "file finder", it can search
    -- many different aspects of Neovim, your workspace, LSP, and more!
    --
    -- The easiest way to use telescope, is to start by doing something like:
    --  :Telescope help_tags
    --
    -- After running this command, a window will open up and you're able to
    -- type in the prompt window. You'll see a list of help_tags options and
    -- a corresponding preview of the help.
    --
    -- Two important keymaps to use while in telescope are:
    --  - Insert mode: <c-/>
    --  - Normal mode: ?
    --
    -- This opens a window that shows you all of the keymaps for the current
    -- telescope picker. This is really useful to discover what Telescope can
    -- do as well as how to actually do it!

    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`
    require("telescope").setup({
      -- You can put your default mappings / updates / etc. in here
      --  All the info you're looking for is in `:help telescope.setup()`
      --
      -- defaults = {
      --   mappings = {
      --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
      --   },
      -- },
      -- pickers = {}
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
      },
    })

    -- Enable telescope extensions, if they are installed
    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "ui-select")

    -- See `:help telescope.builtin`
    local builtin = require("telescope.builtin")

    -- Ultra usefull. Find files and find text in files
    vim.keymap.set("n", "<leader>a", builtin.live_grep, { desc = "[S]earch by [G]rep" })
    vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })

    vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
    vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
    vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
    vim.keymap.set("n", "<leader>sc", builtin.grep_string, { desc = "[S]earch [C]urrent word" })
    vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
    vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
    vim.keymap.set("n", "<leader>b", builtin.buffers, { desc = "[ ] Find existing buffers" })

    -- Slightly advanced example of overriding default behavior and theme
    vim.keymap.set("n", "<leader>/", function()
      -- You can pass additional configuration to telescope to change theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
      }))
    end, { desc = "[/] Fuzzily search in current buffer" })

    -- Also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set("n", "<leader>s/", function()
      builtin.live_grep({
        grep_open_files = true,
        prompt_title = "Live Grep in Open Files",
      })
    end, { desc = "[S]earch [/] in Open Files" })

    -- Shortcut for searching your neovim configuration files
    vim.keymap.set("n", "<leader>sn", function()
      builtin.find_files({ cwd = vim.fn.stdpath("config") })
    end, { desc = "[S]earch [N]eovim files" })

    -- Registers, with a previewer that shows the raw (multi-line) contents.
    -- The default picker collapses newlines to "\n" in the result line, so the
    -- preview pane is where you actually read multi-line registers.
    --
    -- What each special register holds (see `:help registers`):
    local register_help = {
      ['"'] = "Unnamed register: last delete or yank",
      ["-"] = "Small delete: deletes of less than one line",
      ["0"] = "Yank register: text from the most recent yank",
      ["#"] = "Alternate file name (the # in commands)",
      ["="] = "Expression register: <CR> opens the = prompt to type an expression, then p to paste",
      ["/"] = "Last search pattern",
      ["*"] = "Selection register (PRIMARY on X11)",
      ["+"] = "System clipboard (CLIPBOARD)",
      [":"] = "Last command-line",
      ["."] = "Last inserted text",
      ["%"] = "Current file name",
    }
    -- 1-9 are the numbered delete/change history; a-z are your named registers.
    for i = 1, 9 do
      register_help[tostring(i)] = "Numbered register: delete/change history (1 = most recent)"
    end
    for c = string.byte("a"), string.byte("z") do
      register_help[string.char(c)] = 'Named register "' .. string.char(c) .. '" (set with "' .. string.char(c) .. ')'
    end

    local register_previewer = require("telescope.previewers").new_buffer_previewer({
      title = "Register Contents",
      define_preview = function(self, entry)
        local desc = register_help[entry.value] or "Register"
        local lines = { "# [" .. entry.value .. "] " .. desc, "" }
        local content = entry.content or ""
        if content == "" then
          table.insert(lines, "(empty)")
        else
          for _, l in ipairs(vim.split(content, "\n")) do
            table.insert(lines, l)
          end
        end
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
        -- Light up the header line so it reads as a label, not register content.
        vim.api.nvim_buf_add_highlight(self.state.bufnr, -1, "Comment", 0, 0, -1)
      end,
    })
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    vim.keymap.set("n", '<leader>"', function()
      builtin.registers({
        previewer = register_previewer,
        -- The builtin's own attach_mappings runs first (it sets <CR> = paste and
        -- <C-e> = edit), then ours runs and overrides <CR> only for "=", which
        -- has nothing to paste: instead we replicate native `"=` and drop into
        -- the expression command-line so you can type an expression, then `p`.
        attach_mappings = function(_, _map)
          actions.select_default:replace(function(prompt_bufnr)
            local entry = action_state.get_selected_entry()
            if entry and entry.value == "=" then
              actions.close(prompt_bufnr)
              vim.api.nvim_feedkeys('"=', "n", false)
            else
              actions.paste_register(prompt_bufnr)
            end
          end)
          return true
        end,
      })
    end, { desc = '[ ] Search [\"]Registers' })
  end,
}
