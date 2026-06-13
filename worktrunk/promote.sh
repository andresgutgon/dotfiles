#!/usr/bin/env sh
# Promote a worktree's branch into the main worktree, carrying its Claude agent.
#
# Normally removing a worktree orphans the Claude session running in it: the
# process is left in a deleted directory and its transcript stays keyed to the
# gone worktree path. To keep the "promote -> QA in main -> keep talking to the
# agent" flow working, we first re-home the live agent into the main worktree
# with Claude's `/cd` command (sent over tmux). `/cd` moves the agent's working
# directory AND relocates its session transcript into the target's project dir,
# so the conversation stays live and resumable from main. Only then do we remove
# the worktree (keeping the branch) and check that branch out in the main
# worktree.
#
# Usage: promote.sh <worktree-path> <primary-path> <branch>
#   Run detached (the worktree this runs from gets removed).
set -u

WT="$1"       # worktree being promoted
PRIMARY="$2"  # main worktree
BRANCH="$3"

# Don't sit inside the worktree we're about to remove.
cd "$PRIMARY" 2>/dev/null || true

# Refuse a dirty worktree. `wt remove` would fail on it anyway, and crucially we
# must not move the agent away with `/cd` before we know the promote can finish
# -- otherwise the agent ends up in main while the worktree is still there.
if [ -n "$(git -C "$WT" status --porcelain 2>/dev/null)" ]; then
  echo "promote: '$WT' has uncommitted changes -- commit or stash first; not promoting." >&2
  exit 1
fi

# Find the tmux session whose active pane sits in the worktree -- that's the
# Claude agent for this branch (sidekick- or spawn-task-started). Matches by cwd
# only; in this workflow a worktree's pane is the agent.
SESSION=$(tmux list-panes -a -F '#{session_name}|#{pane_current_path}' 2>/dev/null \
  | awk -F'|' -v wt="$WT" '$2 == wt { print $1; exit }')

if [ -n "$SESSION" ]; then
  # Re-home the agent to main before the worktree disappears.
  tmux send-keys -t "$SESSION" "/cd $PRIMARY" Enter
  # Wait until its cwd actually moved (so the dir is free to remove), max ~15s.
  i=0
  while [ "$(tmux display-message -p -t "$SESSION" '#{pane_current_path}' 2>/dev/null)" != "$PRIMARY" ] \
    && [ "$i" -lt 30 ]; do
    sleep 0.5
    i=$((i + 1))
  done
fi

wt remove --no-delete-branch --yes "$BRANCH"
git -C "$PRIMARY" checkout "$BRANCH"
