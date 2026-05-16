#!/usr/bin/env bash
# Claude Code status line

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name')
# five_hour=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // 0')
five_hour=90
seven_day=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // 0')

RESET=$'\033[0m'
GRAY=$'\033[38;2;160;160;160m'
MAGENTA=$'\033[35m'
DIM=$'\033[2m'

bar() {
  local pct=$1
  local filled=$(( pct * 10 / 100 ))
  local empty=$(( 10 - filled ))
  local color
  if [ "$pct" -ge 90 ]; then
    color=$'\033[38;2;220;110;110m'
  elif [ "$pct" -ge 40 ]; then
    color=$'\033[38;2;210;190;100m'
  else
    color=$'\033[38;2;110;200;110m'
  fi
  local b="${color}"
  for ((i=0; i<filled; i++)); do
    local tip="━"
    (( i == filled - 1 )) && tip="╸"
    b+="${tip}"
  done
  b+="${RESET}"
  for ((i=0; i<empty; i++)); do b+="─"; done
  printf "%s" "$b"
}

five_bar=$(bar "$five_hour")
seven_bar=$(bar "$seven_day")

printf "⠀\n\n"
printf "%s  5h %s %s%d%%%s  7d %s %s%d%%%s  %s%s%s\n" \
  "${DIM}andresgutgon@gmail.com${RESET}" \
  "$five_bar" "$GRAY" "$five_hour" "$RESET" \
  "$seven_bar" "$GRAY" "$seven_day" "$RESET" \
  "${MAGENTA}" "$model" "${RESET}"
printf "⠀\n"
