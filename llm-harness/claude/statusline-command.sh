#!/usr/bin/env bash
# Claude Code status line

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LATITUDE_64=$(cat "$SCRIPT_DIR/latitude-logo.txt" 2>/dev/null)

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name')
five_hour=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // 0')
seven_day=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // 0')

claude_json=$(cat ~/.claude.json 2>/dev/null)
email=$(echo "$claude_json" | jq -r '.oauthAccount.emailAddress // ""')
display_name=$(echo "$claude_json" | jq -r '.oauthAccount.displayName // "Me"')
org_type=$(echo "$claude_json" | jq -r '.oauthAccount.organizationType // ""')

case "$org_type" in
  claude_pro)         plan="Pro" ;;
  claude_max_5x)      plan="Max 5x" ;;
  claude_max_20x)     plan="Max 20x" ;;
  claude_team*)       plan="Team" ;;
  claude_enterprise*) plan="Enterprise" ;;
  free|claude_free)   plan="Free" ;;
  *)                  plan="$org_type" ;;
esac

is_personal=false
[[ "$email" == *@gmail.com ]] && is_personal=true
latitude_logo=$(printf '\033]1337;File=inline=1;width=auto;height=auto:%s\a' "$LATITUDE_64")

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
if $is_personal; then
  printf "${DIM}%s – %s${RESET}  5h %s %s%d%%%s  7d %s %s%d%%%s  %s%s%s\n" \
    "$display_name" "$plan" \
    "$five_bar" "$GRAY" "$five_hour" "$RESET" \
    "$seven_bar" "$GRAY" "$seven_day" "$RESET" \
    "${MAGENTA}" "$model" "${RESET}"
else
  printf "%s\n" "$latitude_logo"
  printf "  5h %s %s%d%%%s  7d %s %s%d%%%s  %s%s%s\n" \
    "$five_bar" "$GRAY" "$five_hour" "$RESET" \
    "$seven_bar" "$GRAY" "$seven_day" "$RESET" \
    "${MAGENTA}" "$model" "${RESET}"
fi
printf "⠀\n"
