#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

PARENT="${NAME:-$1}"
[[ -n "$PARENT" ]] || exit 0

DRAWING="$(sketchybar --query "$PARENT" 2>/dev/null | /opt/homebrew/bin/jq -r '.popup.drawing // "off"')"
if [[ "$DRAWING" == "on" ]]; then
  sketchybar --set "$PARENT" popup.drawing=off
  exit 0
fi

# Keep a single popup open and give its contents a restrained two-point settle.
for popup in apple time wifi battery volume_icon weather; do
  [[ "$popup" == "$PARENT" ]] || sketchybar --set "$popup" popup.drawing=off 2>/dev/null
done

ESCAPED_PARENT="${PARENT//./\\.}"
ITEMS="/^${ESCAPED_PARENT}\\..*/"
sketchybar --set "$ITEMS" y_offset=-2 \
  --set "$PARENT" popup.drawing=on
sketchybar --animate tanh 9 --set "$ITEMS" y_offset=0
