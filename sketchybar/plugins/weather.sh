#!/bin/bash

source "$HOME/.config/sketchybar/icons.sh"
source "$HOME/.config/sketchybar/environment.sh"

lat=$(echo "{LAT}" | shortcuts run "Get Location" | tee)
lon=$(echo "{LON}" | shortcuts run "Get Location" | tee)

response=$(curl --silent "https://api.openweathermap.org/data/3.0/onecall?lat=${lat}&lon=${lon}&appid=$WEATHER_API_KEY")
temperature_kelvin=$(echo $response | jq -r '.current.temp')
condition=$(echo $response | jq -r '.current.weather[0].id')
description=$(echo $response | jq -r '.current.weather[0].description')
temperature=$(echo "scale=2; $temperature_kelvin - 273.15" | bc  | cut -c 1-4)
is_night=$(echo $response | jq -r '.current.sunset,.current.sunrise' | awk '{print $1-$2}' | awk '{if ($1 < 0) print 1; else print 0}' | head -n 1)

if (( description == "null" )); then
    description="Weather unavailable"
fi

if (( condition >= 200 && condition <= 299 )); then
    sketchybar --set weather icon="$THUNDERSTORM"
elif (( condition >= 300 && condition <= 399 )); then
    sketchybar --set weather icon="$DRIZZLE"
elif (( condition >= 500 && condition <= 599 )); then
    sketchybar --set weather icon="$RAIN"
elif (( condition >= 600 && condition <= 699 )); then
    sketchybar --set weather icon="$SNOW"
elif (( condition >= 700 && condition <= 799 )); then
    sketchybar --set weather icon="$ATMOSPHERE"
elif (( condition == 800 && is_night == 0 )); then
    sketchybar --set weather icon="$CLEAR"
elif (( condition == 800 && is_night == 1 )); then
    sketchybar --set weather icon="$CLEAR_NIGHT"
elif (( condition > 800 && condition <= 802 && is_night == 0 )); then
    sketchybar --set weather icon="$CLOUDS_LIGHT"
elif (( condition > 800 && condition <= 802 && is_night == 1 )); then
    sketchybar --set weather icon="$CLOUDS_LIGHT_NIGHT"
elif (( condition > 802 && condition <= 804 && is_night == 0 )); then
    sketchybar --set weather icon="$CLOUDS"
elif (( condition > 802 && condition <= 804 && is_night == 1 )); then
    sketchybar --set weather icon="$CLOUDS_NIGHT"
else
    sketchybar --set weather icon="$WEATHER_UNAVAILABLE"
fi

weather_popup_info=(
  icon="$IP"
  icon.padding_left=10
  label="$description"
  label.y_offset=0
  label.padding_left=10
  label.padding_right=10
  label.font="SF Pro:Bold:12.0"
  height=10
  blur_radius=100
)

sketchybar --add item weather.info popup.weather \
  --set weather.info "${weather_popup_info[@]}"


weather_popup_temperature=(
  icon="$TEMPERATURE"
  icon.padding_left=12
  label="$temperature °C"
  label.y_offset=0
  label.padding_left=12
  label.padding_right=10
  label.font="SF Pro:Bold:12.0"
  height=10
  blur_radius=100
)

sketchybar --add item weather.temperature popup.weather \
  --set weather.temperature "${weather_popup_temperature[@]}"