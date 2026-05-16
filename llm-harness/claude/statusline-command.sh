#!/usr/bin/env bash
# Claude Code status line

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name')
five_hour=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // 0')
seven_day=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // 0')

RESET=$'\033[0m'
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
RED=$'\033[31m'
MAGENTA=$'\033[35m'
DIM=$'\033[2m'

bar() {
  local pct=$1
  local filled=$(( pct * 10 / 100 ))
  local empty=$(( 10 - filled ))
  local b=""
  for ((i=0; i<filled; i++)); do b+="▪"; done
  for ((i=0; i<empty; i++)); do b+="▫"; done
  echo "$b"
}

rate_color() {
  local pct=$1
  if [ "$pct" -ge 80 ]; then echo "$RED"
  elif [ "$pct" -ge 50 ]; then echo "$YELLOW"
  else echo "$GREEN"
  fi
}

five_bar=$(bar "$five_hour")
seven_bar=$(bar "$seven_day")
five_color=$(rate_color "$five_hour")
seven_color=$(rate_color "$seven_day")

printf "%s  5h %s%s%s %d%%  7d %s%s%s %d%%  %s%s%s\n" \
  "${DIM}andresgutgon@gmail.com${RESET}" \
  "$five_color" "$five_bar" "$RESET" "$five_hour" \
  "$seven_color" "$seven_bar" "$RESET" "$seven_day" \
  "${MAGENTA}" "$model" "${RESET}"
printf "⠀\n"
