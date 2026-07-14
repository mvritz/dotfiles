#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"
source "$HOME/.config/sketchybar/plugins/bar_hover.sh"
handle_bar_hover && exit 0

ANIMATION_LOCK="${TMPDIR:-/tmp}/sketchybar-volume/animation-lock"
if [[ "$SENDER" == "volume_change" && -f "$ANIMATION_LOCK" ]]; then
  LOCK_AGE=$(( $(/bin/date +%s) - $(/usr/bin/stat -f %m "$ANIMATION_LOCK" 2>/dev/null || printf '0') ))
  if (( LOCK_AGE < 2 )); then
    exit 0
  fi
  rm -f "$ANIMATION_LOCK"
fi

PERCENTAGE="$INFO"
if ! [[ "$PERCENTAGE" =~ ^[0-9]+$ ]]; then
  PERCENTAGE="$(/usr/bin/osascript -e 'output volume of (get volume settings)' 2>/dev/null)"
fi
MUTED="$(/usr/bin/osascript -e 'output muted of (get volume settings)' 2>/dev/null)"

case "$MUTED:$PERCENTAGE" in
  true:*) ICON="$VOLUME_0" ;;
  false:[6-9][0-9]|false:100) ICON="$VOLUME" ;;
  false:[3-5][0-9]) ICON="$VOLUME_66" ;;
  false:[1-2][0-9]) ICON="$VOLUME_33" ;;
  false:[1-9]) ICON="$VOLUME_10" ;;
  false:0) ICON="$VOLUME_0" ;;
  *) ICON="$VOLUME_66" ;;
esac

sketchybar --set "${NAME:-volume_icon}" label="$ICON"
