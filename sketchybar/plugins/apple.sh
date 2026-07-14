#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"

PLUGIN_DIR="$HOME/.config/sketchybar/plugins"
source "$PLUGIN_DIR/bar_hover.sh"
handle_bar_hover && exit 0
source "$PLUGIN_DIR/popup_style.sh"

sketchybar --remove '/apple\.popup\..*/' >/dev/null 2>&1
sketchybar --add item apple.popup.header popup.apple \
  --set apple.popup.header label="Quick Actions" icon="$APPLE" "${POPUP_HEADER[@]}" \
  --add item apple.popup.settings popup.apple \
  --set apple.popup.settings label="System Settings" icon="$SETTINGS" "${POPUP_ACTION[@]}" \
    script="$PLUGIN_DIR/popup_hover.sh" \
    click_script="open -a 'System Settings'; sketchybar --set apple popup.drawing=off" \
  --subscribe apple.popup.settings mouse.entered mouse.exited \
  --add item apple.popup.activity popup.apple \
  --set apple.popup.activity label="Activity Monitor" icon="$ACTIVITY" "${POPUP_ACTION[@]}" \
    script="$PLUGIN_DIR/popup_hover.sh" \
    click_script="open -a 'Activity Monitor'; sketchybar --set apple popup.drawing=off" \
  --subscribe apple.popup.activity mouse.entered mouse.exited \
  --add item apple.popup.lock popup.apple \
  --set apple.popup.lock label="Lock Screen" icon="$LOCK" "${POPUP_ACTION[@]}" \
    script="$PLUGIN_DIR/popup_hover.sh" \
    click_script="pmset displaysleepnow; sketchybar --set apple popup.drawing=off" \
  --subscribe apple.popup.lock mouse.entered mouse.exited \
  --add item apple.popup.sleep popup.apple \
  --set apple.popup.sleep label="Sleep" icon="$SLEEP" "${POPUP_ACTION[@]}" \
    script="$PLUGIN_DIR/popup_hover.sh" \
    click_script="pmset sleepnow; sketchybar --set apple popup.drawing=off" \
  --subscribe apple.popup.sleep mouse.entered mouse.exited
