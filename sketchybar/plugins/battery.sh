#!/bin/sh

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"

PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')
POPUP_CLICK_SCRIPT="sketchybar --set \$NAME popup.drawing=toggle"

batt() {
  if [ $PERCENTAGE = "" ]; then
    exit 0
  fi

  case ${PERCENTAGE} in
  9[0-9] | 100)
    ICON="$BATTERY"
    ;;
  [6-8][0-9])
    ICON="$BATTERY_75"
    ;;
  [3-5][0-9])
    ICON="$BATTERY_50"
    ;;
  [1-2][0-9])
    ICON="$BATTERY_25"
    ;;
  *) ICON="$BATTERY_0" ;;
  esac

  if [[ $CHARGING != "" ]]; then
    ICON="$BATTERY_LOADING"
  fi

  sketchybar --set $NAME icon="$ICON"
}

if [ "$(pmset -g batt | grep "Battery")" != "" ]; then
  batt
else
  sketchybar --remove battery
  exit 0
fi

battery_popup=(
  icon=$ICON
  icon.padding_left=10
  label="$PERCENTAGE %"
  label.y_offset=0
  label.padding_left=10
  label.padding_right=10
  label.font="SF Pro:Bold:12.0"
  height=10
  blur_radius=100
)

sketchybar --add item battery.popup popup.battery \
  --set battery.popup "${battery_popup[@]}"
