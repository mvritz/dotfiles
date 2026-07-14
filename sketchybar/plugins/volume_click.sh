#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"
source "$HOME/.config/sketchybar/plugins/popup_style.sh"

STATE_DIR="${TMPDIR:-/tmp}/sketchybar-volume"
TOKEN_FILE="$STATE_DIR/animation-token"
ANIMATION_LOCK="$STATE_DIR/animation-lock"
mkdir -p "$STATE_DIR"

volume_icon_for_percentage() {
  case "$1" in
    [6-9][0-9]|100) printf '%s' "$VOLUME" ;;
    [3-5][0-9]) printf '%s' "$VOLUME_66" ;;
    [1-2][0-9]) printf '%s' "$VOLUME_33" ;;
    [1-9]) printf '%s' "$VOLUME_10" ;;
    *) printf '%s' "$VOLUME_0" ;;
  esac
}

animate_volume_toggle() {
  local was_muted="$1" percentage="$2" current_icon token frame final_icon
  local frames=()

  current_icon="$(volume_icon_for_percentage "$percentage")"
  if [[ "$was_muted" == "true" ]]; then
    frames=("$VOLUME_0")
    case "$current_icon" in
      "$VOLUME_10") frames+=("$VOLUME_10") ;;
      "$VOLUME_33") frames+=("$VOLUME_10" "$VOLUME_33") ;;
      "$VOLUME_66") frames+=("$VOLUME_10" "$VOLUME_33" "$VOLUME_66") ;;
      "$VOLUME") frames+=("$VOLUME_10" "$VOLUME_33" "$VOLUME_66" "$VOLUME") ;;
    esac
    final_icon="$current_icon"
  else
    case "$current_icon" in
      "$VOLUME") frames=("$VOLUME" "$VOLUME_66" "$VOLUME_33" "$VOLUME_10" "$VOLUME_0") ;;
      "$VOLUME_66") frames=("$VOLUME_66" "$VOLUME_33" "$VOLUME_10" "$VOLUME_0") ;;
      "$VOLUME_33") frames=("$VOLUME_33" "$VOLUME_10" "$VOLUME_0") ;;
      "$VOLUME_10") frames=("$VOLUME_10" "$VOLUME_0") ;;
      *) frames=("$VOLUME_0") ;;
    esac
    final_icon="$VOLUME_0"
  fi

  token="$$-$RANDOM"
  printf '%s\n' "$token" > "$TOKEN_FILE"

  sketchybar --animate tanh 4 \
    --set volume_icon label.color="$TOKYO_EVENT" label.y_offset=-2

  for frame in "${frames[@]}"; do
    [[ "$(/bin/cat "$TOKEN_FILE" 2>/dev/null)" == "$token" ]] || return 0
    sketchybar --set volume_icon label="$frame"
    sleep 0.035
  done

  [[ "$(/bin/cat "$TOKEN_FILE" 2>/dev/null)" == "$token" ]] || return 0
  sketchybar --set volume_icon label="$final_icon" \
    --animate sin 5 --set volume_icon label.y_offset=1 \
    --animate tanh 7 --set volume_icon label.y_offset=0 label.color="$TOKYO_FG"
}

toggle_mute() {
  local settings muted percentage
  printf '%s\n' "$$" > "$ANIMATION_LOCK"
  settings="$(/usr/bin/osascript \
    -e 'set currentSettings to get volume settings' \
    -e 'set previousVolume to output volume of currentSettings' \
    -e 'set previousMuted to output muted of currentSettings' \
    -e 'if previousMuted then' \
    -e 'set volume without output muted' \
    -e 'else' \
    -e 'set volume with output muted' \
    -e 'end if' \
    -e 'return (previousVolume as text) & "|" & (previousMuted as text)' 2>/dev/null)"

  if [[ "$settings" != *"|"* ]]; then
    rm -f "$ANIMATION_LOCK"
    sketchybar --trigger volume_change
    return 1
  fi

  percentage="${settings%%|*}"
  muted="${settings#*|}"
  [[ "$percentage" =~ ^[0-9]+$ ]] || percentage=50

  animate_volume_toggle "$muted" "$percentage"
  rm -f "$ANIMATION_LOCK"
  sketchybar --trigger volume_change
}

toggle_devices() {
  local switch_audio
  switch_audio="$(command -v SwitchAudioSource)"

  if [[ -z "$switch_audio" ]]; then
    sketchybar --remove '/volume.device\..*/' >/dev/null 2>&1
    sketchybar --set volume_icon popup.drawing=toggle \
      --add item volume.device.settings popup.volume_icon \
      --set volume.device.settings icon="$PREFERENCES" label="Sound Settings" \
        "${POPUP_ACTION[@]}" script="$HOME/.config/sketchybar/plugins/popup_hover.sh" \
        click_script="open 'x-apple.systempreferences:com.apple.Sound-Settings.extension'; sketchybar --set volume_icon popup.drawing=off" \
      --subscribe volume.device.settings mouse.entered mouse.exited
    exit 0
  fi

  args=(--remove '/volume.device\..*/' --set volume_icon popup.drawing=toggle)
  COUNTER=0
  CURRENT="$($switch_audio -t output -c)"
  while IFS= read -r device; do
    ITEM="volume.device.$COUNTER"
    printf -v DEVICE_Q '%q' "$device"
    if [[ "$device" == "$CURRENT" ]]; then
      ROW_ICON="$DOT"; ICON_COLOR="$TOKYO_CYAN"; LABEL_COLOR="$TOKYO_FG"; ROW_BG="$TOKYO_POPUP_SELECTED"
    else
      ROW_ICON=" "; ICON_COLOR="$TOKYO_BLUE"; LABEL_COLOR="$TOKYO_MUTED"; ROW_BG="$TOKYO_POPUP_ROW"
    fi

    args+=(--add item "$ITEM" popup.volume_icon
      --set "$ITEM" "${POPUP_ACTION[@]}"
      label="$device" label.color="$LABEL_COLOR"
      icon="$ROW_ICON" icon.color="$ICON_COLOR"
      background.color="$ROW_BG"
      script="$HOME/.config/sketchybar/plugins/popup_hover.sh"
      click_script="$switch_audio -s $DEVICE_Q; sketchybar --set volume_icon popup.drawing=off")
    args+=(--subscribe "$ITEM" mouse.entered mouse.exited)
    COUNTER=$((COUNTER + 1))
  done <<<"$($switch_audio -a -t output)"

  args+=(--add item volume.device.settings popup.volume_icon
    --set volume.device.settings "${POPUP_ACTION[@]}"
    icon="$SETTINGS" label="Sound Settings"
    script="$HOME/.config/sketchybar/plugins/popup_hover.sh"
    click_script="open 'x-apple.systempreferences:com.apple.Sound-Settings.extension'; sketchybar --set volume_icon popup.drawing=off"
    --subscribe volume.device.settings mouse.entered mouse.exited)

  sketchybar "${args[@]}" >/dev/null
}

if [[ "$BUTTON" == "right" || "$MODIFIER" == "shift" ]]; then toggle_devices; else toggle_mute; fi
