#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"
source "$HOME/.config/sketchybar/environment.sh"

PLUGIN_DIR="$HOME/.config/sketchybar/plugins"
source "$PLUGIN_DIR/bar_hover.sh"
handle_bar_hover && exit 0
source "$PLUGIN_DIR/popup_style.sh"

STATE_DIR="${TMPDIR:-/tmp}/sketchybar-pacman"
CACHE_FILE="$STATE_DIR/weather-cache"
mkdir -p "$STATE_DIR"

run_with_timeout() {
  local seconds="$1"
  shift
  /usr/bin/perl -e '$seconds = shift @ARGV; alarm $seconds; exec @ARGV' "$seconds" "$@"
}

weather_icon() {
  local condition="$1"
  local hour="$(date +%H)"
  if (( condition >= 200 && condition <= 299 )); then printf '%s' "$THUNDERSTORM"
  elif (( condition >= 300 && condition <= 399 )); then printf '%s' "$DRIZZLE"
  elif (( condition >= 500 && condition <= 599 )); then printf '%s' "$RAIN"
  elif (( condition >= 600 && condition <= 699 )); then printf '%s' "$SNOW"
  elif (( condition >= 700 && condition <= 799 )); then printf '%s' "$ATMOSPHERE"
  elif (( condition == 800 )); then
    if (( hour >= 22 || hour < 6 )); then printf '%s' "$CLEAR_NIGHT"; else printf '%s' "$CLEAR"; fi
  elif (( condition >= 801 && condition <= 802 )); then
    if (( hour >= 22 || hour < 6 )); then printf '%s' "$CLOUDS_LIGHT_NIGHT"; else printf '%s' "$CLOUDS_LIGHT"; fi
  elif (( condition >= 803 && condition <= 804 )); then
    if (( hour >= 22 || hour < 6 )); then printf '%s' "$CLOUDS_NIGHT"; else printf '%s' "$CLOUDS"; fi
  else printf '%s' "$WEATHER_UNAVAILABLE"
  fi
}

fetch_weather() {
  local lat lon response temperature_raw feels_raw humidity wind_raw uv_raw visibility_raw
  local condition description icon temperature feels wind uv visibility updated
  local sunrise sunset hourly_temps hourly_hours rain_chance
  lat="$(printf '{LAT}' | run_with_timeout 6 /usr/bin/shortcuts run "Get Location" 2>/dev/null | /usr/bin/tr -d '\r\n ')"
  lon="$(printf '{LON}' | run_with_timeout 6 /usr/bin/shortcuts run "Get Location" 2>/dev/null | /usr/bin/tr -d '\r\n ')"
  [[ "$lat" =~ ^-?[0-9]+([.][0-9]+)?$ && "$lon" =~ ^-?[0-9]+([.][0-9]+)?$ ]] || return 1

  response="$(run_with_timeout 10 /usr/bin/curl --silent --fail --max-time 9 \
    "https://api.openweathermap.org/data/3.0/onecall?lat=${lat}&lon=${lon}&units=metric&exclude=minutely,daily,alerts&appid=${WEATHER_API_KEY}" 2>/dev/null)"
  temperature_raw="$(printf '%s' "$response" | /opt/homebrew/bin/jq -r '.current.temp // empty' 2>/dev/null)"
  feels_raw="$(printf '%s' "$response" | /opt/homebrew/bin/jq -r '.current.feels_like // empty' 2>/dev/null)"
  humidity="$(printf '%s' "$response" | /opt/homebrew/bin/jq -r '.current.humidity // empty' 2>/dev/null)"
  wind_raw="$(printf '%s' "$response" | /opt/homebrew/bin/jq -r '.current.wind_speed // empty' 2>/dev/null)"
  uv_raw="$(printf '%s' "$response" | /opt/homebrew/bin/jq -r '.current.uvi // empty' 2>/dev/null)"
  visibility_raw="$(printf '%s' "$response" | /opt/homebrew/bin/jq -r '.current.visibility // empty' 2>/dev/null)"
  condition="$(printf '%s' "$response" | /opt/homebrew/bin/jq -r '.current.weather[0].id // empty' 2>/dev/null)"
  description="$(printf '%s' "$response" | /opt/homebrew/bin/jq -r '.current.weather[0].description // empty' 2>/dev/null)"
  [[ "$temperature_raw" =~ ^-?[0-9]+([.][0-9]+)?$ && "$condition" =~ ^[0-9]+$ && -n "$description" ]] || return 1

  temperature="$(/usr/bin/printf '%.0f' "$temperature_raw")"
  if [[ "$feels_raw" =~ ^-?[0-9]+([.][0-9]+)?$ ]]; then feels="$(/usr/bin/printf '%.0f' "$feels_raw")"; else feels="$temperature"; fi
  [[ "$humidity" =~ ^[0-9]+$ ]] || humidity="--"
  if [[ "$wind_raw" =~ ^[0-9]+([.][0-9]+)?$ ]]; then wind="$(/usr/bin/printf '%.1f' "$wind_raw")"; else wind="--"; fi
  if [[ "$uv_raw" =~ ^[0-9]+([.][0-9]+)?$ ]]; then uv="$(/usr/bin/printf '%.1f' "$uv_raw")"; else uv="--"; fi
  if [[ "$visibility_raw" =~ ^[0-9]+([.][0-9]+)?$ ]]; then visibility="$(/usr/bin/awk -v value="$visibility_raw" 'BEGIN { printf "%.0f", value / 1000 }')"; else visibility="--"; fi
  updated="$(date '+%H:%M')"
  sunrise="$(printf '%s' "$response" | /opt/homebrew/bin/jq -r '.timezone_offset as $offset | ((.current.sunrise + $offset) | strftime("%H:%M"))' 2>/dev/null)"
  sunset="$(printf '%s' "$response" | /opt/homebrew/bin/jq -r '.timezone_offset as $offset | ((.current.sunset + $offset) | strftime("%H:%M"))' 2>/dev/null)"
  hourly_temps="$(printf '%s' "$response" | /opt/homebrew/bin/jq -r '[.hourly[0:8][].temp | round] | join(",")' 2>/dev/null)"
  hourly_hours="$(printf '%s' "$response" | /opt/homebrew/bin/jq -r '.timezone_offset as $offset | [.hourly[0:8][] | ((.dt + $offset) | strftime("%H"))] | join(",")' 2>/dev/null)"
  rain_chance="$(printf '%s' "$response" | /opt/homebrew/bin/jq -r '([.hourly[0:8][].pop // 0] | max * 100 | round) // 0' 2>/dev/null)"
  description="$(printf '%s' "$description" | /usr/bin/awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2); print}')"
  icon="$(weather_icon "$condition")"
  printf '%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n' \
    "$icon" "$temperature" "$description" "$feels" "$humidity" "$wind" "$updated" \
    "$uv" "$visibility" "$sunrise" "$sunset" "$hourly_temps" "$hourly_hours" "$rain_chance" > "$CACHE_FILE"
}

fetch_weather || true
if [[ -s "$CACHE_FILE" ]]; then
  ICON_VALUE="$(/usr/bin/sed -n '1p' "$CACHE_FILE")"
  TEMPERATURE_VALUE="$(/usr/bin/sed -n '2p' "$CACHE_FILE")"
  DESCRIPTION_VALUE="$(/usr/bin/sed -n '3p' "$CACHE_FILE")"
  FEELS_VALUE="$(/usr/bin/sed -n '4p' "$CACHE_FILE")"
  HUMIDITY_VALUE="$(/usr/bin/sed -n '5p' "$CACHE_FILE")"
  WIND_VALUE="$(/usr/bin/sed -n '6p' "$CACHE_FILE")"
  UPDATED_VALUE="$(/usr/bin/sed -n '7p' "$CACHE_FILE")"
  UV_VALUE="$(/usr/bin/sed -n '8p' "$CACHE_FILE")"
  VISIBILITY_VALUE="$(/usr/bin/sed -n '9p' "$CACHE_FILE")"
  SUNRISE_VALUE="$(/usr/bin/sed -n '10p' "$CACHE_FILE")"
  SUNSET_VALUE="$(/usr/bin/sed -n '11p' "$CACHE_FILE")"
  HOURLY_TEMPS="$(/usr/bin/sed -n '12p' "$CACHE_FILE")"
  HOURLY_HOURS="$(/usr/bin/sed -n '13p' "$CACHE_FILE")"
  RAIN_CHANCE="$(/usr/bin/sed -n '14p' "$CACHE_FILE")"
else
  ICON_VALUE="$WEATHER_UNAVAILABLE"
  TEMPERATURE_VALUE="--"
  DESCRIPTION_VALUE="Weather Unavailable"
  FEELS_VALUE="--"
  HUMIDITY_VALUE="--"
  WIND_VALUE="--"
  UPDATED_VALUE="--:--"
  UV_VALUE="--"
  VISIBILITY_VALUE="--"
  SUNRISE_VALUE="--:--"
  SUNSET_VALUE="--:--"
  HOURLY_TEMPS=""
  HOURLY_HOURS=""
  RAIN_CHANCE="--"
fi

[[ -n "$FEELS_VALUE" ]] || FEELS_VALUE="$TEMPERATURE_VALUE"
[[ -n "$HUMIDITY_VALUE" ]] || HUMIDITY_VALUE="--"
[[ -n "$WIND_VALUE" ]] || WIND_VALUE="--"
[[ -n "$UPDATED_VALUE" ]] || UPDATED_VALUE="$(date '+%H:%M')"
[[ -n "$UV_VALUE" ]] || UV_VALUE="--"
[[ -n "$VISIBILITY_VALUE" ]] || VISIBILITY_VALUE="--"
[[ -n "$SUNRISE_VALUE" ]] || SUNRISE_VALUE="--:--"
[[ -n "$SUNSET_VALUE" ]] || SUNSET_VALUE="--:--"
[[ -n "$RAIN_CHANCE" ]] || RAIN_CHANCE="--"

if [[ -z "$HOURLY_TEMPS" ]]; then
  HOURLY_TEMPS="$TEMPERATURE_VALUE,$TEMPERATURE_VALUE,$TEMPERATURE_VALUE,$TEMPERATURE_VALUE,$TEMPERATURE_VALUE,$TEMPERATURE_VALUE,$TEMPERATURE_VALUE,$TEMPERATURE_VALUE"
fi
if [[ -z "$HOURLY_HOURS" ]]; then
  HOURLY_HOURS="Now,+1,+2,+3,+4,+5,+6,+7"
fi

HOURLY_RANGE="$(/usr/bin/awk -F, '{min=$1; max=$1; for(i=2;i<=NF;i++){if($i<min)min=$i;if($i>max)max=$i} printf "%.0f–%.0f°", min, max}' <<< "$HOURLY_TEMPS")"
GRAPH_POINTS="$(/usr/bin/awk -F, '
  {
    min=$1; max=$1; width=232
    for(i=2;i<=NF;i++){if($i<min)min=$i;if($i>max)max=$i}
    for(x=0;x<width;x++){
      pos=x/(width-1)*(NF-1); left=int(pos)+1; fraction=pos-int(pos)
      if(left>=NF) value=$NF; else value=$left*(1-fraction)+$(left+1)*fraction
      if(max==min) normalized=0.5; else normalized=0.16+0.68*(value-min)/(max-min)
      printf "%.4f ", normalized
    }
  }' <<< "$HOURLY_TEMPS")"

IFS=',' read -r HOUR_1 HOUR_2 HOUR_3 HOUR_4 HOUR_5 HOUR_6 HOUR_7 HOUR_8 <<< "$HOURLY_HOURS"
HOUR_LABELS="${HOUR_1}:00      ${HOUR_3}:00      ${HOUR_5}:00      ${HOUR_7}:00"

sketchybar --remove '/weather\..*/' >/dev/null 2>&1
sketchybar --add item weather.hero popup.weather \
  --add item weather.chart_title popup.weather \
  --add graph weather.chart popup.weather 232 \
  --add item weather.chart_labels popup.weather \
  --add item weather.metrics.primary popup.weather \
  --add item weather.metrics.secondary popup.weather \
  --add item weather.sun popup.weather \
  --add item weather.footer popup.weather

sketchybar --set weather icon="$ICON_VALUE" icon.color="$PACMAN_WHITE" \
  --set weather.hero icon="$ICON_VALUE" label="${TEMPERATURE_VALUE}° · ${DESCRIPTION_VALUE}" "${POPUP_HERO[@]}" width=232 \
    icon.font="SF Pro:Semibold:16.0" icon.color="$TOKYO_CYAN" icon.width=30 label.max_chars=27 \
  --set weather.chart_title icon="$TEMPERATURE" label="Next 8 hours · $HOURLY_RANGE" "${POPUP_ROW[@]}" width=232 \
    label.color="$TOKYO_MUTED" \
  --set weather.chart icon.drawing=off label.drawing=off padding_left=4 padding_right=4 \
    background.drawing=on background.color="$TOKYO_BG" background.height=30 background.corner_radius=7 \
    graph.color="$TOKYO_BLUE" graph.fill_color=0x337AA2F7 graph.line_width=2 \
    script="$PLUGIN_DIR/weather_chart_hover.sh" \
  --subscribe weather.chart mouse.entered mouse.exited \
  --set weather.chart_labels icon.drawing=off label="$HOUR_LABELS" width=232 \
    label.font="SF Pro:Medium:9.0" label.color="$TOKYO_COMMENT" label.align=center label.width=220 \
    label.padding_left=6 label.padding_right=6 background.drawing=off \
  --set weather.metrics.primary icon="$HUMIDITY" label="${HUMIDITY_VALUE}% humidity · ${WIND_VALUE} m/s wind" "${POPUP_META[@]}" width=232 \
  --set weather.metrics.secondary icon="$ACTIVITY" label="UV ${UV_VALUE} · Rain ${RAIN_CHANCE}% · ${VISIBILITY_VALUE} km" "${POPUP_META[@]}" width=232 \
  --set weather.sun icon="$CLEAR" label="Sunrise ${SUNRISE_VALUE} · Sunset ${SUNSET_VALUE}" "${POPUP_META[@]}" width=232 \
  --set weather.footer icon="$TIME" label="Updated ${UPDATED_VALUE}" "${POPUP_META[@]}" width=232

# Fill the native graph from edge to edge with interpolated hourly samples.
sketchybar --push weather.chart $GRAPH_POINTS
