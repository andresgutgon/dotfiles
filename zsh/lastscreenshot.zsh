# This script defines a function to get the most recent screenshot file
# from the ~/Documents/screen-recordings directory.
# This is helpful for Cursor CLI users to quickly access their latest screenshot.
#
# You can see where you have screenshots stored by checking your macOS screenshot settings:
# `defaults read com.apple.screencapture location`
lastshot() {
  local dir=~/Documents/screen-recordings
  local latest=$(ls -t "$dir"/Screenshot* 2>/dev/null | head -1)
  if [ -z "$latest" ]; then
    echo "No screenshots found in $dir" >&2
    return 1
  fi
  echo "$latest"
}
