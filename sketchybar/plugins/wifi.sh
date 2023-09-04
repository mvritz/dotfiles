#!/bin/sh

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"

PLUGIN_DIR="$HOME/.config/sketchybar/plugins"
CURRENT_WIFI="$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I)"
SSID="$(echo "$CURRENT_WIFI" | grep -o "SSID: .*" | sed 's/^SSID: //')"
CURR_TX="$(echo "$CURRENT_WIFI" | grep -o "lastTxRate: .*" | sed 's/^lastTxRate: //')"
POPUP_OFF="sketchybar --set wifi.ssid popup.drawing=off && sketchybar --set wifi.speed popup.drawing=off"
WIFI_INTERFACE=$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}')
WIFI_POWER=$(networksetup -getairportpower $WIFI_INTERFACE | awk '{print $4}')
IP_ADDR=$(ipconfig getifaddr $WIFI_INTERFACE)

ssid=(
  icon=$NETWORK
  icon.padding_left=10
  label="$SSID"
  label.font="SF Pro:Bold:12.0"
  label.padding_left=10
  label.padding_right=10
  blur_radius=100
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
  blur_radius=100
  sticky=on
  click_script="open /System/Library/PreferencePanes/Network.prefPane/; $POPUP_OFF"
)

sketchybar --add item wifi.ip popup.wifi \
  --set wifi.ip "${ip[@]}"

speed=(
  icon=$SPEED
  icon.padding_left=10
  label.font="SF Pro:Bold:12.0"
  label.padding_left=10
  label.padding_right=10
  blur_radius=100
  sticky=on
  update_freq=10
  width=125
  script="$PLUGIN_DIR/speed.sh"
)

sketchybar --add item wifi.speed popup.wifi \
  --set wifi.speed "${speed[@]}"

if [ ! -f /tmp/sketchybar_wifi ]; then
  touch /tmp/sketchybar_wifi
fi

if [ ! -f /tmp/sketchybar_speed ]; then
  (
    COUNTER=0
    END_TIME=$(($(date +%s) + 9))
    while [ $(date +%s) -lt $END_TIME ]; do
      case $COUNTER in
      0) LABEL="Loading." ;;
      1) LABEL="Loading.." ;;
      2) LABEL="Loading..." ;;
      esac
      sketchybar --set wifi.speed label="$LABEL"
      sleep 1
      COUNTER=$(((COUNTER + 1) % 3))
    done
  ) &
fi

if [ "$WIFI_POWER" == "Off" ]; then
  sketchybar --set $NAME label=$WIFI_OFF
  exit 0
fi

SSID_LOWER=$(echo "$SSID" | tr '[:upper:]' '[:lower:]')
if [[ "$SSID_LOWER" == *iphone* ]]; then
  sketchybar --set $NAME label=$HOTSPOT
  exit 0
fi

if [ $CURR_TX = 0 ]; then
  sketchybar --set $NAME label=$WIFI_NO_INTERNET
  exit 0
fi

sketchybar --set $NAME label=$WIFI
