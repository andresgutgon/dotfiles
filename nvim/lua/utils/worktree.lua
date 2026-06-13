-- Worktree <-> sidekick glue.
--
-- Driven from lazygit's worktree commands (see lazygit/config.yml): on switch,
-- lazygit calls `:WorktreeSwitch <path>` over the nvim RPC server, then closes
-- its own terminal. This cd's into the worktree and brings up that worktree's
-- claude agent in the sidekick panel -- re-attaching to a live one or
-- starting/resuming a fresh one, all scoped to the worktree's cwd.

local M = {}

-- Attach (or start) the claude agent for the current cwd and show it.
local function open()
  pcall(function()
    local State = require("sidekick.cli.state")
    local Session = require("sidekick.cli.session")
    local Terminal = require("sidekick.cli.terminal")
    local cwd = Session.cwd()

    -- Classify the claude candidates for this worktree:
    --   live        -- a sidekick-managed session (its tmux session is named
    --                  with sidekick's own sid), directly embeddable.
    --   external    -- a session sidekick discovered but didn't create, e.g. a
    --                  `spawn-task` agent in a branch-named tmux session.
    --   placeholder -- no session yet; we'll start one.
    local live, external, placeholder
    for _, s in ipairs(State.get({ name = "claude" })) do
      if s.session and s.session.cwd == cwd then
        if s.external then
          external = external or s
        else
          live = s
        end
      elseif not s.session then
        placeholder = s
      end
    end

    -- Hide other worktrees' panels SYNCHRONOUSLY -- never this cwd's. sidekick's
    -- own hide() double-defers terminal:hide(), so it lands after our attach and
    -- re-hides the target. Hiding the non-targets ourselves, up front, sidesteps
    -- that race.
    for _, term in pairs(Terminal.terminals) do
      if term.cwd ~= cwd and term:is_open() then
        pcall(function()
          term:hide()
        end)
      end
    end

    -- focus = false: show the panel but keep the cursor in nvim, since this is
    -- driven from lazygit, not from a deliberate jump into chat.
    if live then
      State.attach(live, { show = true, focus = false })
    elseif external then
      -- A `spawn-task` (or otherwise externally-started) agent: reuse it instead
      -- of starting a parallel one. sidekick only embeds a session whose sid
      -- matches its tmux session name, so point sid at the discovered session
      -- name -- attach then opens `tmux attach-session -t <name>` in the panel.
      external.session.sid = external.session.mux_session
      State.attach(external, { show = true, focus = false })
    elseif placeholder then
      -- No embeddable agent yet: start one. Resume the worktree's last
      -- conversation (`claude --continue`) only when one exists on disk -- a
      -- history-less `claude --continue` exits at once and would close the
      -- panel, so use a plain `claude` there. Claude stores per-cwd history
      -- under ~/.claude/projects/<cwd with every non-alphanumeric char replaced
      -- by `-`>.
      local cmd = vim.deepcopy(placeholder.tool.cmd)
      local encoded = cwd:gsub("[^%w]", "-")
      local history = vim.fn.glob(vim.fn.expand("~/.claude/projects/") .. encoded .. "/*.jsonl") ~= ""
      if history then
        vim.list_extend(cmd, placeholder.tool.continue or {})
      end
      -- Build the session with the cloned tool so `attach` keeps the cmd -- it
      -- otherwise re-resolves the tool by name and drops it.
      placeholder.session = Session.new({ tool = placeholder.tool:clone({ cmd = cmd }) })
      State.attach(placeholder, { show = true, focus = false })
    end
  end)
end

-- Register the :WorktreeSwitch <path> command. Call this from sidekick's `init`
-- so the command exists before the plugin loads.
function M.setup()
  vim.api.nvim_create_user_command("WorktreeSwitch", function(opts)
    vim.cmd.cd(vim.fs.normalize(opts.args))
    -- When invoked from lazygit the current buffer is lazygit's terminal, which
    -- is about to close -- wait for it so the panel doesn't steal focus back.
    if vim.bo.buftype == "terminal" then
      vim.api.nvim_create_autocmd("TermClose", {
        once = true,
        callback = function()
          vim.schedule(open)
        end,
      })
    else
      open()
    end
  end, { nargs = 1, complete = "dir", desc = "cd to worktree and attach its sidekick agent" })
end

return M
