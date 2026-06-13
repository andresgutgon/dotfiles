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
detached-in-tmux `claude` yourself. The rule that matters: for this "I'll drive
them from my editor" workflow, launch **real detached `claude` processes in
tmux**, never ephemeral subagents (the Task/Agent tool). Subagents get buried in
your own session, aren't independently resumable, and never show up when I
switch to the worktree.

## Background agents / subagents — your call

If I *don't* specifically ask for tmux worktree sessions, use your own judgment
about subagents vs. native background agents (`claude agents`) vs. doing the work
inline. I only insist on the tmux-worktree approach above when I say I want to
work on several tasks in parallel and switch between them myself.
