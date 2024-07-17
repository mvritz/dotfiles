#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"

SSID="$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}' | xargs networksetup -getairportnetwork | cut -d ':' -f 2- | xargs)"
CURR_TX="$(wdutil info | grep "Tx Rate" | awk '{print int($4)}')"
POPUP_OFF="sketchybar --set wifi.ssid popup.drawing=off && sketchybar --set wifi.speed popup.drawing=off"
WIFI_INTERFACE=$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}')
WIFI_POWER=$(networksetup -getairportpower $WIFI_INTERFACE | awk '{print $4}')
IP_ADDR=$(ipconfig getifaddr $WIFI_INTERFACE)

ssid=(
  icon="$NETWORK"
  icon.padding_left=10
  label="$SSID"
  label.font="SF Pro:Bold:12.0"
  label.padding_left=10
  label.padding_right=10
  blur_radius=0
  sticky=on
  update_freq=100
  click_script="open /System/Library/PreferencePanes/Network.prefPane/; $POPUP_OFF"
)

sketchybar --add item wifi.ssid popup.wifi \
  --set wifi.ssid "${ssid[@]}"

ip=(
  icon=$IP
  icon.padding_left=10
  label="$IP_ADDR"
  label.font="SF Pro:Bold:12.0"
  label.padding_left=10
  label.padding_right=10
  blur_radius=0
  sticky=on
  click_script="open /System/Library/PreferencePanes/Network.prefPane/; $POPUP_OFF"
)

sketchybar --add item wifi.ip popup.wifi \
  --set wifi.ip "${ip[@]}"

if [ "$WIFI_POWER" == "Off" ]; then
  sketchybar --set "$NAME" label=$WIFI_OFF
  exit 0
fi

SSID_LOWER=$(echo "$SSID" | tr '[:upper:]' '[:lower:]')
if [[ "$SSID_LOWER" == *iphone* ]]; then
  sketchybar --set $NAME label=$HOTSPOT
  exit 0
fi

if [ "$CURR_TX" = 0 ]; then
  sketchybar --set "$NAME" label=$WIFI_NO_INTERNET
  exit 0
fi

sketchybar --set "$NAME" label=$WIFI
