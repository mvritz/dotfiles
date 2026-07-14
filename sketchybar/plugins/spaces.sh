#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"
source "$HOME/.config/sketchybar/environment.sh"

STATE_DIR="${TMPDIR:-/tmp}/sketchybar-pacman"
ACTIVE_FILE="$STATE_DIR/active-space"
TOKEN_FILE="$STATE_DIR/animation-token"
mkdir -p "$STATE_DIR"

ACTIVE_SPACE="$(/opt/homebrew/bin/yabai -m query --spaces --space 2>/dev/null | /opt/homebrew/bin/jq -r '.index // empty')"
SPACE_COUNT="${#SPACE_GHOSTS[@]}"
[[ "$ACTIVE_SPACE" =~ ^[0-9]+$ ]] || exit 0
(( ACTIVE_SPACE >= 1 && ACTIVE_SPACE <= SPACE_COUNT )) || exit 0

PREVIOUS_SPACE="$(/bin/cat "$ACTIVE_FILE" 2>/dev/null)"
TOKEN="$$-$RANDOM"
printf '%s\n' "$TOKEN" > "$TOKEN_FILE"
printf '%s\n' "$ACTIVE_SPACE" > "$ACTIVE_FILE"

ghost_color() { printf '%s' "${SPACE_GHOST_COLORS[$((($1 - 1) % ${#SPACE_GHOST_COLORS[@]}))]}"; }
ghost_icon() { printf '%s' "${SPACE_GHOSTS[$((($1 - 1) % ${#SPACE_GHOSTS[@]}))]}"; }
is_current_animation() { [[ "$(/bin/cat "$TOKEN_FILE" 2>/dev/null)" == "$TOKEN" ]]; }

# Coalesce duplicate space events before touching the visible track.
sleep 0.03
is_current_animation || exit 0

set_pacman() {
  sketchybar --set "space.$1" icon="$PACMAN" icon.color="$PACMAN_WHITE" icon.y_offset=0 \
    background.color="$TRANSPARENT" background.height=18 background.border_width=1 \
    background.border_color="$TRANSPARENT" background.shadow.drawing=off
}

reset_track() {
  local sid args=()
  for ((sid = 1; sid <= SPACE_COUNT; sid++)); do
    args+=(--set "space.$sid" icon="$(ghost_icon "$sid")" icon.color="$(ghost_color "$sid")" icon.y_offset=0 \
      background.color="$TRANSPARENT" background.height=18 background.border_width=1 \
      background.border_color="$TRANSPARENT" background.shadow.drawing=off)
  done
  sketchybar "${args[@]}"
}

settle_active_space() {
  set_pacman "$1"
  sketchybar --animate circ 6 \
    --set "space.$1" icon.y_offset=-3 icon.color="$PACMAN_WHITE" background.color="$TRANSPARENT" background.border_color="$TRANSPARENT" \
    --animate sin 9 \
    --set "space.$1" icon.y_offset=0 icon.color="$PACMAN_WHITE" background.color="$TRANSPARENT" background.border_color="$TRANSPARENT" \
    --animate sin 8 --set control background.border_color="$TOKYO_EVENT" \
    --animate sin 12 --set control background.border_color="$TOKYO_BORDER"
}

if ! [[ "$PREVIOUS_SPACE" =~ ^[0-9]+$ ]] || (( PREVIOUS_SPACE < 1 || PREVIOUS_SPACE > SPACE_COUNT )); then
  reset_track; settle_active_space "$ACTIVE_SPACE"; exit 0
fi
if (( PREVIOUS_SPACE == ACTIVE_SPACE )); then
  reset_track; set_pacman "$ACTIVE_SPACE"; exit 0
fi

reset_track
set_pacman "$PREVIOUS_SPACE"
if (( ACTIVE_SPACE > PREVIOUS_SPACE )); then STEP=1; else STEP=-1; fi

sketchybar --animate tanh 5 --set "space.$PREVIOUS_SPACE" icon.y_offset=-2 icon.color="$PACMAN_WHITE" \
  background.color="$TRANSPARENT" background.border_color="$TRANSPARENT"
sleep 0.035
is_current_animation || exit 0

LAST_SPACE="$PREVIOUS_SPACE"
NEXT_SPACE=$((PREVIOUS_SPACE + STEP))
while :; do
  sketchybar --animate quadratic 4 \
    --set "space.$LAST_SPACE" icon="$(ghost_icon "$LAST_SPACE")" icon.color="$(ghost_color "$LAST_SPACE")" icon.y_offset=0 \
      background.color="$TRANSPARENT" background.height=18 background.border_color="$TRANSPARENT" background.shadow.drawing=off \
    --set "space.$NEXT_SPACE" icon="$PACMAN" icon.color="$PACMAN_WHITE" icon.y_offset=-2 \
      background.color="$TRANSPARENT" background.height=18 background.border_color="$TRANSPARENT" background.shadow.drawing=off
  sleep 0.045
  is_current_animation || exit 0
  (( NEXT_SPACE == ACTIVE_SPACE )) && break
  LAST_SPACE="$NEXT_SPACE"
  NEXT_SPACE=$((NEXT_SPACE + STEP))
done

settle_active_space "$ACTIVE_SPACE"
