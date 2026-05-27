-- Open the plan that belongs to the *focused sidekick panel's* project.
-- Plans live globally in ~/.claude/plans/ with no project/session marker, so a
-- plan is mapped back to its project by content-matching it against that
-- project's session transcripts. The matching logic lives in find_plan.py next
-- to this file. This is why opening "the newest plan" globally is wrong when
-- several Claude sessions run at once — the newest plan often belongs to a
-- different project.
local PLAN_FINDER = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h") .. "/find_plan.py"

-- Resolve the cwd of the focused (or otherwise visible) sidekick terminal,
-- using the session id sidekick stamps onto its terminal window.
local function sidekick_panel_cwd()
  local ok, State = pcall(require, "sidekick.cli.state")
  if not ok then
    return nil
  end
  local ok_states, states = pcall(State.get)
  if not ok_states or type(states) ~= "table" then
    return nil
  end
  local function cwd_for(session_id)
    for _, st in ipairs(states) do
      if st.session and st.session.id == session_id and st.session.cwd then
        return st.session.cwd
      end
    end
  end
  local cur = vim.api.nvim_get_current_win()
  local wins = { cur }
  for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if w ~= cur then
      wins[#wins + 1] = w
    end
  end
  for _, w in ipairs(wins) do
    local okv, sid = pcall(vim.api.nvim_win_get_var, w, "sidekick_session_id")
    if okv and sid and sid ~= "" then
      local cwd = cwd_for(sid)
      if cwd then
        return cwd
      end
    end
  end
end

local function open_current_plan()
  local cwd = sidekick_panel_cwd() or vim.fn.getcwd()
  local out = vim.fn.system({ "python3", PLAN_FINDER, cwd })
  local plan = vim.trim(out or "")
  local where = vim.fn.fnamemodify(cwd, ":~")
  if vim.v.shell_error ~= 0 or plan == "" then
    vim.notify("No plan found for " .. where, vim.log.levels.WARN)
    return
  end
  vim.cmd.edit(vim.fn.fnameescape(plan))
  vim.notify("Plan: " .. vim.fn.fnamemodify(plan, ":t") .. "  (" .. where .. ")")
end

return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,      -- enable/disable suggestions
          auto_trigger = true, -- show automatically as you type
          debounce = 75,       -- lower debounce = faster suggestions
          keymap = {
            accept = "<Tab>",  -- accept suggestion
            accept_word = "<C-w>",
            accept_line = "<C-e>",
            next = "<M-]>",    -- cycle forward (Alt-])
            prev = "<M-[>",    -- cycle backward (Alt-[)
            dismiss = "<C-c>", -- dismiss suggestion
          },
        },
      })
    end,
  },
  {
    "folke/sidekick.nvim",
    opts = {
      -- add any options here
      cli = {
        mux = {
          backend = "tmux",
          enabled = true,
        },
      },
    },
    keys = {

      {
        "<tab>",
        function()
          -- Skip for Neo-tree and other special buffers
          local buf_name = vim.api.nvim_buf_get_name(0)
          local filetype = vim.bo.filetype
          if filetype == "neo-tree" or filetype == "neo-tree-popup" or buf_name:match("neo%-tree") then
            return "<tab>"
          end

          -- if there is a next edit, jump to it, otherwise apply it if any
          if require("sidekick").nes_jump_or_apply() then
            return -- jumped or applied
          end

          -- if you are using Neovim's native inline completions
          if vim.lsp.inline_completion.get() then
            return
          end

          -- any other things (like snippets) you want to do on <tab> go here.

          -- fall back to normal tab
          return "<tab>"
        end,
        mode = { "i", "n" },
        expr = true,
        desc = "Goto/Apply Next Edit Suggestion",
      },
      {
        "<c-.>",
        function()
          require("sidekick.cli").toggle()
        end,
        desc = "Sidekick Toggle",
        mode = { "n", "t", "i", "x" },
      },
      {
        "<leader>aa",
        function()
          require("sidekick.cli").toggle()
        end,
        desc = "Sidekick Toggle CLI",
      },
      {
        "<leader>al",
        function()
          require("sidekick.cli").select({ filter = { installed = true } })
        end,
        -- Or to select only installed tools:
        desc = "Select CLI",
      },
      {
        "<leader>ad",
        function()
          require("sidekick.cli").close()
        end,
        desc = "Detach a CLI Session",
      },
      {
        "<leader>at",
        function()
          require("sidekick.cli").send({ msg = "{this}" })
        end,
        mode = { "x", "n" },
        desc = "Send This",
      },
      {
        "<leader>af",
        function()
          require("sidekick.cli").send({ msg = "{file}" })
        end,
        desc = "Send File",
      },
      {
        "<leader>av",
        function()
          require("sidekick.cli").send({ msg = "{selection}" })
        end,
        mode = { "x" },
        desc = "Send Visual Selection",
      },
      {
        "<leader>ap",
        function()
          require("sidekick.cli").prompt()
        end,
        mode = { "n", "x" },
        desc = "Sidekick Select Prompt",
      },
      -- Example of a keybinding to open Claude directly
      {
        "<leader>ac",
        function()
          require("sidekick.cli").toggle({ name = "cursor", focus = true })
        end,
        desc = "Sidekick Toggle Claude",
      },
      {
        "<leader>ai",
        function()
          require("sidekick.cli").send({
            msg = "Read the image: $(source ~/dotfiles/zsh/lastscreenshot.zsh && lastshot) and ",
          })
        end,
        desc = "Send Last Screenshot",
      },
      {
        "<leader>ao",
        open_current_plan,
        desc = "Open Current Plan",
      },
    },
  },
}
