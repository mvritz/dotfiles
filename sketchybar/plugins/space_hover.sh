#!/bin/bash

case "$SENDER" in
  mouse.entered)
    sketchybar --animate tanh 5 --set "$NAME" icon.y_offset=-1
    ;;
  mouse.exited)
    sketchybar --animate sin 7 --set "$NAME" icon.y_offset=0
    ;;
esac
