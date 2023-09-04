#!/bin/sh

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"

POPUP_OFF="sketchybar --set apple.logo popup.drawing=off"
POPUP_CLICK_SCRIPT="sketchybar --set \$NAME popup.drawing=toggle"
COUNT=$(brew outdated | wc -l | tr -d ' ')

properties=(
  label.y_offset=0
  label.padding_left=10
  label.padding_right=10
  label.font="SF Pro:Bold:12.0"
  icon.font="SF Pro:Regular:14.0"
  icon.padding_left=10
  height=10
  blur_radius=100
  width=175
)

sketchybar --add item apple.popup.activity popup.apple \
  --set apple.popup.activity label="Activity Monitor" \
  icon=$ACTIVITY "${properties[@]}" \
  click_script="open -a 'Activity Monitor'" \
  \
  --add item apple.popup.brew popup.apple \
  --set apple.popup.brew label="Homebrew ($COUNT)" \
  icon=$BREW "${properties[@]}" \
  \
  --add item apple.popup.lock popup.apple \
  --set apple.popup.lock label="Lock Screen" \
  icon=$LOCK "${properties[@]}" \
  click_script="pmset displaysleepnow" \
  \
  --add item apple.popup.settings popup.apple \
  --set apple.popup.settings label="System Preferences" \
  icon=$PREFERENCES "${properties[@]}" \
  click_script="open -a 'System Preferences'" \
  \
  --add item apple.popup.restart popup.apple \
  --set apple.popup.restart label="Restart" \
  icon=$RESTART "${properties[@]}" \
  click_script="reboot" \
  \
  --add item apple.popup.shutdown popup.apple \
  --set apple.popup.shutdown label="Shut down" \
  icon=$OFF "${properties[@]}" \
  click_script="halt"
