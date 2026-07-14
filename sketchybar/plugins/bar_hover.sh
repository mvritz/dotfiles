#!/bin/bash

handle_bar_hover() {
  case "$SENDER" in
    mouse.entered)
      sketchybar --animate tanh 5 \
        --set "$NAME" icon.y_offset=-1 label.y_offset=-1
      return 0
      ;;
    mouse.exited)
      sketchybar --animate sin 7 \
        --set "$NAME" icon.y_offset=0 label.y_offset=0
      return 0
      ;;
  esac
  return 1
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then handle_bar_hover; fi
