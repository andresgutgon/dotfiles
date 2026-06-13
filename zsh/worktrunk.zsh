# Spawn a background tmux session running Claude inside a worktree.
# Each task gets its own worktree + Claude session keyed to that worktree's
# path, so `claude -c` resumes it and the lazygit worktree switch re-attaches it
# in Sidekick.
#
# Usage: spawn-task <branch> <task description...>
#   - New branch      -> created off the repo's default branch (wt's default).
#                        Override the base with SPAWN_TASK_BASE: a branch name,
#                        or a wt shortcut like `@` (current HEAD), `pr:123`, etc.
#   - Existing branch -> its worktree is opened as-is (SPAWN_TASK_BASE ignored).
#   Run once per task to fan a Linear group out across worktrees.
#   Must be run inside tmux.
spawn-task() {
  if [[ -z "$1" || -z "$2" ]]; then
    echo "usage: spawn-task <branch> <task description>" >&2
    return 1
  fi
  if [[ -z "$TMUX" ]]; then
    echo "spawn-task: must be run inside tmux" >&2
    return 1
  fi

  local branch="$1"; shift
  local task="$*"

  # tmux session names can't contain "." or ":"
  local session="${branch//\//-}"
  session="${session//./-}"

  # If the branch already exists (locally or as a fetched remote-tracking ref),
  # open its worktree. Otherwise create it from SPAWN_TASK_BASE, or -- when unset
  # -- let wt branch off the repo's default branch (no convention needed).
  local cmd
  if git show-ref --verify --quiet "refs/heads/${branch}" 2>/dev/null \
    || git show-ref --verify --quiet "refs/remotes/origin/${branch}" 2>/dev/null; then
    cmd="wt switch ${(q)branch} -x claude -- ${(q)task}"
  elif [[ -n "$SPAWN_TASK_BASE" ]]; then
    cmd="wt switch --create ${(q)branch} --base ${(q)SPAWN_TASK_BASE} -x claude -- ${(q)task}"
  else
    cmd="wt switch --create ${(q)branch} -x claude -- ${(q)task}"
  fi

  tmux new-session -d -s "$session" "$cmd"
  echo "spawned ${branch} → tmux attach -t ${session}"
}
