#!/bin/sh

CURRENT_WIFI="$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I)"
CURR_TX="$(echo "$CURRENT_WIFI" | grep -o "lastTxRate: .*" | sed 's/^lastTxRate: //')"

rm -f /tmp/sketchybar_wifi
if [ ! -f /tmp/sketchybar_speed ]; then
  touch /tmp/sketchybar_speed
fi

sketchybar --set $NAME label="${CURR_TX} MB/s"
