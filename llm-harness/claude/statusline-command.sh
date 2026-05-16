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
  local b=""
  for ((i=0; i<filled; i++)); do
    local v=$(( 80 + i * 175 / 9 ))
    local tip="━"
    (( i == filled - 1 )) && tip="╸"
    if [ "$pct" -ge 80 ]; then
      b+=$'\033'"[38;2;${v};100;100m${tip}"
    else
      b+=$'\033'"[38;2;100;${v};100m${tip}"
    fi
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
