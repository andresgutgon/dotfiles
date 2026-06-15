# Global instructions

## Parallel work on multiple tasks

When I want to work on several tasks at once and **jump between them in my
editor** — switch tmux panes / lazygit worktrees, with the live agent embedded
in nvim via Sidekick — spin each task up as its own **detached `claude` process
in a tmux session, rooted in its own git worktree** (one per task).

The `spawn-task` shell function is just syntax sugar for this; call it once per
task:

    spawn-task <branch> <task description...>

For a new branch it creates the worktree off the repo's default branch (no
convention — `wt` figures that out); pass `SPAWN_TASK_BASE` to base it on
something else (a branch name, or a `wt` shortcut like `@` for the current
HEAD). If the branch already exists it just opens its worktree. Either way it
boots `claude` inside that worktree seeded with the task and runs it detached in
tmux. Because Claude's cwd is the worktree, its session is keyed to that
worktree's path — so `claude -c` resumes it and the lazygit worktree switch
re-attaches it in Sidekick. Defined in `~/dotfiles/zsh/worktrunk.zsh`; requires
being inside tmux.

You don't strictly need the function — you can create the worktree and launch a
detached-in-tmux `claude` yourself. The one rule, and it applies **only to this
editor-driven workflow**: launch real detached `claude` processes in tmux, not
subagents — a subagent would get buried in your own session, isn't independently
resumable, and never shows up when I switch to the worktree. (Subagents are great
everywhere else — see below.)

### Lifecycle of a spawned task — it runs to a PR, not to a pause

A detached worktree agent's job is to make the change **fast**, run the repo's
typecheck/tests, then **commit and open a PR** (following the repo's
branch/base-branch + PR conventions). `spawn-task` injects this contract into
every seeded prompt automatically, so the agent does it without being asked. An
open PR is my **manual-review surface — not a claim the work is finished or
ready**, so the agent never waits for my sign-off before committing/opening it.
This is the deliberate **exception** to my usual "make edits, then stop and wait
for review before committing" rule: that rule governs inline main-session work;
detached worktree agents commit and PR on their own.

I then review by jumping between worktrees in my editor (lazygit / Sidekick).
For each worktree I accept I **promote** it — lazygit `p` / `promote.sh` carries
that worktree's branch *and its live agent* into `main` (it refuses if the
worktree is dirty) — and then analyze the combined result. So a branch showing
up in `main` is a deliberate promote, never a mistake.

## Subagents & background agents — use them freely

The rule above is *only* about tasks I intend to open and drive myself. For
anything I'm **not** going to sit in — research, delegated or parallel subtasks,
fan-out exploration, verification, work whose result you just hand back to me —
reach for subagents (the Task/Agent tool) and native background agents (`claude
agents`) **without hesitation**. That's exactly what they're for. Don't avoid
them, and don't grind through everything inline to stay out of them: spinning up
a subagent to go research or parallelize something is a *good* default, not
something you need to clear with me first. The tmux-worktree approach is a narrow
exception for work I'll drive myself — not a signal that I dislike agents. If
anything, lean into them.
