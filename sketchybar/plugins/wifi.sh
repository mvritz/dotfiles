#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"

PLUGIN_DIR="$HOME/.config/sketchybar/plugins"
source "$PLUGIN_DIR/bar_hover.sh"
handle_bar_hover && exit 0
source "$PLUGIN_DIR/popup_style.sh"

cached_wifi_ssid() {
  local interface="$1" hex cache_strings preferred

  hex="$(printf 'show State:/Network/Interface/%s/AirPort\n' "$interface" \
    | /usr/sbin/scutil \
    | /usr/bin/awk '/CachedScanRecord/{sub(/^.*0x/, ""); print; exit}')"
  [[ -n "$hex" ]] || return 1

  cache_strings="$(printf '%s' "$hex" | /usr/bin/xxd -r -p | LC_ALL=C /usr/bin/strings)"
  [[ -n "$cache_strings" ]] || return 1

  /usr/sbin/networksetup -listpreferredwirelessnetworks "$interface" 2>/dev/null \
    | /usr/bin/tail -n +2 \
    | /usr/bin/sed 's/^[[:space:]]*//' \
    | while IFS= read -r preferred; do
        [[ -n "$preferred" ]] || continue
        if printf '%s\n' "$cache_strings" | /usr/bin/grep -Fqx "$preferred"; then
          printf '%s' "$preferred"
          break
        fi
      done
}

ITEM="${NAME:-wifi}"
INTERFACE="$(/usr/sbin/networksetup -listallhardwareports | /usr/bin/awk '/Wi-Fi|AirPort/{getline; print $2; exit}')"
POWER=""
SSID=""
IP_ADDR=""
ROUTER_ADDR=""
SECURITY=""
SUMMARY=""

if [[ -n "$INTERFACE" ]]; then
  POWER="$(/usr/sbin/networksetup -getairportpower "$INTERFACE" 2>/dev/null | /usr/bin/awk '{print $NF}')"
  SUMMARY="$(/usr/sbin/ipconfig getsummary "$INTERFACE" 2>/dev/null)"
  SSID="$(printf '%s\n' "$SUMMARY" | /usr/bin/awk -F ': ' '/^[[:space:]]*SSID[[:space:]]*:/{print $2; exit}')"
  ROUTER_ADDR="$(printf '%s\n' "$SUMMARY" | /usr/bin/awk -F ': ' '/^[[:space:]]*Router[[:space:]]*:/{print $2; exit}')"
  SECURITY="$(printf '%s\n' "$SUMMARY" | /usr/bin/awk -F ': ' '/^[[:space:]]*Security[[:space:]]*:/{print $2; exit}')"
  IP_ADDR="$(/usr/sbin/ipconfig getifaddr "$INTERFACE" 2>/dev/null)"

  if [[ "$SSID" == "<redacted>" || -z "$SSID" ]]; then
    SSID="$(cached_wifi_ssid "$INTERFACE")"
  fi
fi

if [[ -z "$INTERFACE" || "$POWER" == "Off" ]]; then
  MAIN_ICON="$WIFI_OFF"
  SSID_LABEL="Wi-Fi Off"
  CONNECTION_LABEL="Wireless disabled"
  IP_LABEL="IP address · Not assigned"
  ROUTER_LABEL="Router · Not available"
elif [[ "$(printf '%s' "$SSID" | /usr/bin/tr '[:upper:]' '[:lower:]')" == *iphone* ]]; then
  MAIN_ICON="$HOTSPOT"
  SSID_LABEL="${SSID:-Personal Hotspot}"
  CONNECTION_LABEL="Connected · Personal Hotspot"
  IP_LABEL="IP address · ${IP_ADDR:-Not assigned}"
  ROUTER_LABEL="Router · ${ROUTER_ADDR:-Not available}"
elif [[ -z "$SSID" ]]; then
  MAIN_ICON="$WIFI_NO_INTERNET"
  SSID_LABEL="Not Connected"
  CONNECTION_LABEL="No active network"
  IP_LABEL="IP address · Not assigned"
  ROUTER_LABEL="Router · Not available"
else
  MAIN_ICON="$WIFI"
  SSID_LABEL="$SSID"
  SECURITY_LABEL="${SECURITY//_/ }"
  [[ -n "$SECURITY_LABEL" ]] || SECURITY_LABEL="Secured"
  CONNECTION_LABEL="Connected · $SECURITY_LABEL"
  IP_LABEL="IP address · ${IP_ADDR:-Not assigned}"
  ROUTER_LABEL="Router · ${ROUTER_ADDR:-Not available}"
fi

sketchybar --remove wifi.ssid >/dev/null 2>&1
for popup_item in wifi.header wifi.status wifi.ip wifi.router wifi.settings; do
  if ! sketchybar --query "$popup_item" >/dev/null 2>&1; then
    sketchybar --add item "$popup_item" popup.wifi
  fi
done

sketchybar --set "$ITEM" label="$MAIN_ICON" \
  --set wifi.header icon="$MAIN_ICON" label="$SSID_LABEL" "${POPUP_HEADER[@]}" \
  --set wifi.status icon="$DOT" label="$CONNECTION_LABEL" "${POPUP_META[@]}" icon.color="$TOKYO_GREEN" \
  --set wifi.ip icon="$IP" label="$IP_LABEL" "${POPUP_META[@]}" \
  --set wifi.router icon="$ROUTER" label="$ROUTER_LABEL" "${POPUP_META[@]}" \
  --set wifi.settings icon="$SETTINGS" label="Open Network Settings" "${POPUP_ACTION[@]}" \
    script="$PLUGIN_DIR/popup_hover.sh" \
    click_script="open 'x-apple.systempreferences:com.apple.wifi-settings-extension'; sketchybar --set wifi popup.drawing=off" \
  --subscribe wifi.settings mouse.entered mouse.exited
