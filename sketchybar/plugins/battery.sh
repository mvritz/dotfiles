#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"

PLUGIN_DIR="$HOME/.config/sketchybar/plugins"
source "$PLUGIN_DIR/bar_hover.sh"
handle_bar_hover && exit 0
source "$PLUGIN_DIR/popup_style.sh"

ITEM="${NAME:-battery}"
BATTERY_INFO="$(/usr/bin/pmset -g batt)"
PERCENTAGE="$(printf '%s' "$BATTERY_INFO" | /usr/bin/grep -Eo '[0-9]+%' | /usr/bin/head -1 | /usr/bin/cut -d% -f1)"

if [[ -z "$PERCENTAGE" ]]; then
  sketchybar --set "$ITEM" drawing=off
  exit 0
fi

case "$PERCENTAGE" in
  9[0-9]|100) ICON="$BATTERY" ;;
  [6-8][0-9]) ICON="$BATTERY_75" ;;
  [3-5][0-9]) ICON="$BATTERY_50" ;;
  [1-2][0-9]) ICON="$BATTERY_25" ;;
  *) ICON="$BATTERY_0" ;;
esac

if [[ "$BATTERY_INFO" == *"AC Power"* ]]; then
  ICON="$BATTERY_LOADING"
  STATE="Charging"
else
  STATE="On Battery"
fi

REMAINING="$(printf '%s\n' "$BATTERY_INFO" | /usr/bin/awk -F'; *' '/InternalBattery/{for(i=1;i<=NF;i++) if($i ~ /remaining|charged/) {gsub(/^[[:space:]]+|[[:space:]]+$/, "", $i); print $i; exit}}')"
REMAINING="${REMAINING%% present:*}"
if [[ "$REMAINING" =~ ^([0-9]+):([0-9]+)[[:space:]]remaining$ ]]; then
  HOURS="${BASH_REMATCH[1]}"
  MINUTES="${BASH_REMATCH[2]}"
  if (( HOURS > 0 )); then REMAINING="${HOURS}h ${MINUTES}m"; else REMAINING="${MINUTES}m"; fi
fi
DETAIL="$STATE"
if [[ -n "$REMAINING" && "$REMAINING" != "0:00 remaining" && "$REMAINING" != "charged" ]]; then
  DETAIL="$STATE · $REMAINING"
fi

POWER_PROFILE="$(/usr/sbin/system_profiler SPPowerDataType 2>/dev/null)"
CYCLE_COUNT="$(printf '%s\n' "$POWER_PROFILE" | /usr/bin/awk -F ': ' '/Cycle Count/{print $2; exit}')"
CONDITION="$(printf '%s\n' "$POWER_PROFILE" | /usr/bin/awk -F ': ' '/Condition/{print $2; exit}')"
MAX_CAPACITY="$(printf '%s\n' "$POWER_PROFILE" | /usr/bin/awk -F ': ' '/Maximum Capacity/{print $2; exit}')"
[[ -n "$CYCLE_COUNT" ]] || CYCLE_COUNT="--"
[[ -n "$CONDITION" ]] || CONDITION="Unknown"
[[ -n "$MAX_CAPACITY" ]] || MAX_CAPACITY="--"

if [[ -n "$REMAINING" && "$REMAINING" != "charged" ]]; then
  ESTIMATE_LABEL="$REMAINING remaining"
else
  ESTIMATE_LABEL="$STATE"
fi

sketchybar --remove battery.popup battery.summary battery.state battery.settings >/dev/null 2>&1
for popup_item in battery.card.hero battery.card.estimate battery.card.health battery.card.cycles battery.card.settings; do
  if ! sketchybar --query "$popup_item" >/dev/null 2>&1; then
    sketchybar --add item "$popup_item" popup.battery
  fi
done

sketchybar --set "$ITEM" drawing=on icon="$ICON" \
  --set battery.card.hero icon="$ICON" label="${PERCENTAGE}% · ${STATE}" "${POPUP_HERO[@]}" \
  --set battery.card.estimate icon="$TIME" label="$ESTIMATE_LABEL" "${POPUP_META[@]}" \
  --set battery.card.health icon="$HEALTH" label="$CONDITION · ${MAX_CAPACITY} maximum" "${POPUP_META[@]}" \
  --set battery.card.cycles icon="$ACTIVITY" label="$CYCLE_COUNT charge cycles" "${POPUP_META[@]}" \
  --set battery.card.settings icon="$SETTINGS" label="Battery Settings" "${POPUP_ACTION[@]}" \
    script="$PLUGIN_DIR/popup_hover.sh" \
    click_script="open 'x-apple.systempreferences:com.apple.Battery-Settings.extension'; sketchybar --set battery popup.drawing=off" \
  --subscribe battery.card.settings mouse.entered mouse.exited
