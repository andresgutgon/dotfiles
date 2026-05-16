#!/usr/bin/env bash
# Claude Code status line.
#
# Latitude logo glyph:
#   This script prints the Latitude logo from a patched HackNerdFontMono font.
#   The font is patched by ~/dotfiles/latitude-font-patch/repatch.sh (re-run it
#   after `brew upgrade` if the Hack Nerd Font has been updated).
#
#   Four sizes are available, mapped to consecutive Private Use Area code points:
#     U+E000  $'\xEE\x80\x80'   1x   fits inside one terminal cell (baseline)
#     U+E001  $'\xEE\x80\x81'   2x   small overflow into neighbouring cells
#     U+E002  $'\xEE\x80\x82'   3x   moderate overflow
#     U+E003  $'\xEE\x80\x83'   4x   big overflow (needs blank space around it)
#
#   The 2x/3x/4x variants are a single colored glyph whose outline deliberately
#   extends past its cell. They rely on iTerm2 (and Core Text) allowing glyphs
#   to overflow their cell. They DO render correctly inside tmux in practice
#   because the surrounding cells in this status line are empty.
#
#   If you switch sizes and adjacent text/bars get clobbered by the logo's
#   horizontal overflow, either drop a size or add padding spaces in `label`
#   (line 64 below) immediately after ${latitude_logo}.

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
latitude_logo=$'\xEE\x80\x82' # U+E001=2x  U+E002=3x  U+E003=4x  U+E000=1x

RESET=$'\033[0m'
GRAY=$'\033[38;2;160;160;160m'
MAGENTA=$'\033[35m'
DIM=$'\033[2m'
BOLD=$'\033[1m'

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

if $is_personal; then
  label="${DIM}${display_name} – ${plan}${RESET}"
else
  label="${BOLD}${latitude_logo}${RESET}${DIM}   – ${plan}${RESET}"
fi

printf "⠀\n"
printf "%s ${DIM}–${RESET} ${MAGENTA}%s${RESET}  5h %s %s%d%%%s  7d %s %s%d%%%s\n" \
  "$label" "$model" \
  "$five_bar" "$GRAY" "$five_hour" "$RESET" \
  "$seven_bar" "$GRAY" "$seven_day" "$RESET"
printf "⠀\n"
