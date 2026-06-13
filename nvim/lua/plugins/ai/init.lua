-- Open the plan that belongs to the *focused sidekick panel's* project.
-- Plans live globally in ~/.claude/plans/ with no project/session marker, so a
-- plan is mapped back to its project by content-matching it against that
-- project's session transcripts. The matching logic lives in find_plan.py next
-- to this file. This is why opening "the newest plan" globally is wrong when
-- several Claude sessions run at once — the newest plan often belongs to a
-- different project.
local PLAN_FINDER = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h") .. "/find_plan.py"
local worktree = require("utils.worktree")

-- Resolve the sidekick session shown in the focused (or otherwise visible)
-- terminal, using the session id sidekick stamps onto its terminal window.
-- This targets "the agent I'm looking at" regardless of nvim's cwd, which can
-- drift away from the agent (e.g. after a promote `cd` or an agent `/cd`).
local function sidekick_panel_session()
  local ok, State = pcall(require, "sidekick.cli.state")
  if not ok then
    return nil
  end
  local ok_states, states = pcall(State.get)
  if not ok_states or type(states) ~= "table" then
    return nil
  end
  local function by_id(session_id)
    for _, st in ipairs(states) do
      if st.session and st.session.id == session_id then
        return st
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
      local st = by_id(sid)
      if st then
        return st
      end
    end
  end
end

local function sidekick_panel_cwd()
  local s = sidekick_panel_session()
  return s and s.session and s.session.cwd or nil
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
    init = function()
      worktree.setup()
    end,
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
          -- Detach the agent shown in the panel (robust to nvim's cwd drifting
          -- from the agent). Fall back to this cwd's session if no panel is up.
          local s = sidekick_panel_session()
          require("sidekick.cli").close(s and { filter = { session = s.session.id } } or { filter = { cwd = true } })
        end,
        desc = "Detach a CLI Session",
      },
      {
        "<leader>aK",
        function()
          -- Actually KILL the agent shown in the panel. close()/<leader>ad only
          -- detaches the nvim terminal; the tmux session keeps running. Kill the
          -- underlying tmux session so the claude process is gone.
          local s = sidekick_panel_session()
          local mux = s and s.session and s.session.mux_session
          if not mux then
            -- no panel up: fall back to this worktree's session
            local State = require("sidekick.cli.state")
            local cwd = require("sidekick.cli.session").cwd()
            for _, c in ipairs(State.get({ name = "claude" })) do
              if c.session and c.session.cwd == cwd and c.session.mux_session then
                mux = c.session.mux_session
                break
              end
            end
          end
          if mux then
            vim.fn.jobstart({ "tmux", "kill-session", "-t", mux })
          else
            vim.notify("No claude agent found to kill", vim.log.levels.WARN)
          end
        end,
        desc = "Kill this worktree's agent",
      },
      {
        "<leader>at",
        function()
          require("sidekick.cli").send({ msg = "{this}", filter = { cwd = true } })
        end,
        mode = { "x", "n" },
        desc = "Send This",
      },
      {
        "<leader>af",
        function()
          require("sidekick.cli").send({ msg = "{file}", filter = { cwd = true } })
        end,
        desc = "Send File",
      },
      {
        "<leader>av",
        function()
          require("sidekick.cli").send({ msg = "{selection}", filter = { cwd = true } })
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
            filter = { cwd = true },
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
