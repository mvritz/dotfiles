#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"

PLUGIN_DIR="$HOME/.config/sketchybar/plugins"
source "$PLUGIN_DIR/bar_hover.sh"
handle_bar_hover && exit 0
source "$PLUGIN_DIR/popup_style.sh"

ITEM="${NAME:-time}"
TIMEZONE="$(/usr/bin/readlink /etc/localtime | /usr/bin/sed 's#^.*/zoneinfo/##')"
[[ -n "$TIMEZONE" ]] || TIMEZONE="Local Time"
CITY="${TIMEZONE##*/}"
CITY="${CITY//_/ }"

sketchybar --remove '/time\.popup.*/' >/dev/null 2>&1
for popup_item in time.card.hero time.card.date time.card.zone time.card.settings; do
  if ! sketchybar --query "$popup_item" >/dev/null 2>&1; then
    sketchybar --add item "$popup_item" popup.time
  fi
done

sketchybar --set "$ITEM" label="$(date '+%H:%M')" \
  --set time.card.hero icon="$TIME" label="$(date '+%H:%M:%S')" "${POPUP_HERO[@]}" \
  --set time.card.date icon="$CALENDAR" label="$(date '+%A, %B %-d')" "${POPUP_ROW[@]}" \
  --set time.card.zone icon="$NETWORK" label="$CITY · $(date '+%Z')" "${POPUP_META[@]}" \
  --set time.card.settings icon="$SETTINGS" label="Date & Time Settings" "${POPUP_ACTION[@]}" \
    script="$PLUGIN_DIR/popup_hover.sh" \
    click_script="open 'x-apple.systempreferences:com.apple.Date-Time-Settings.extension'; sketchybar --set time popup.drawing=off" \
  --subscribe time.card.settings mouse.entered mouse.exited
