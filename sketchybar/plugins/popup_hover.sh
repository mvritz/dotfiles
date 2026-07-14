#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

case "$SENDER" in
  mouse.entered)
    sketchybar --animate tanh 7 \
      --set "$NAME" background.color="$TOKYO_POPUP_SELECTED" \
        icon.color="$TOKYO_CYAN" label.color="$TOKYO_FG"
    ;;
  mouse.exited)
    sketchybar --animate tanh 8 \
      --set "$NAME" background.color="$TOKYO_POPUP_ROW" \
        icon.color="$TOKYO_MUTED" label.color="$TOKYO_FG"
    ;;
esac
