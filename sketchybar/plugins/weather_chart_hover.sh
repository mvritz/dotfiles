#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

case "$SENDER" in
  mouse.entered)
    sketchybar --animate tanh 10 \
      --set weather.chart background.color="$TOKYO_POPUP_SELECTED" \
        graph.color="$TOKYO_CYAN" graph.fill_color=0x557DCFFF \
      --set weather.chart_title label.color="$TOKYO_FG"
    ;;
  mouse.exited)
    sketchybar --animate tanh 12 \
      --set weather.chart background.color="$TOKYO_BG" \
        graph.color="$TOKYO_BLUE" graph.fill_color=0x337AA2F7 \
      --set weather.chart_title label.color="$TOKYO_MUTED"
    ;;
esac
