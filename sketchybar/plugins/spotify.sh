#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"

CURRENT_SONG=$(osascript -e 'tell application "Spotify" to return name of current track')
CURRENT_ARTIST=$(osascript -e 'tell application "Spotify" to return artist of current track')
CURRENT_ALBUM=$(osascript -e 'tell application "Spotify" to return album of current track')
CURRENT_COVER=$(osascript -e 'tell application "Spotify" to return artwork url of current track')
WIDTH=$(((${#CURRENT_SONG} * 10) + 10))

curl -s --max-time 20 "$CURRENT_COVER" -o /tmp/cover.jpg

detail_on() {
  sketchybar --animate sin_in_out 30 --set spotify_label slider.width=$WIDTH opacity=1
}

detail_off() {
  sketchybar --animate sin_in_out 30 --set spotify_label slider.width=0 opacity=0
}

spotify_cover=(
  label.drawing=off
  icon.drawing=off
  padding_left=12
  padding_right=10
  background.image.scale=0.13
  background.image.drawing=on
  background.drawing=on
  background.image="/tmp/cover.jpg"
)

sketchybar --add item spotify.cover popup.spotify \
  --set spotify.cover "${spotify_cover[@]}" \
  --animate sin_in_out 50

spotify_title=(
  label.font="SF Pro:Bold:15.0"
  label="$CURRENT_SONG"
  icon.drawing=off
  padding_left=0
  padding_right=0
  width=0
  label.font="SF Pro:Bold:15.0"
  y_offset=30
  opacity=0
)

sketchybar --add item spotify.title popup.spotify \
  --set spotify.title "${spotify_title[@]}" \
  --animate sin_in_out 30

spotify_artist=(
  icon.drawing=off
  y_offset=7
  padding_left=0
  padding_right=0
  width=0
  label.font="SF Pro:Regular:14.0"
  label="$CURRENT_ARTIST"
  opacity=0
)

sketchybar --add item spotify.artist popup.spotify \
  --set spotify.artist "${spotify_artist[@]}" \
  --animate sin_in_out 30

spotify_album=(
  icon.drawing=off
  padding_left=0
  padding_right=0
  y_offset=-25
  width=0
  label.font="SF Pro:Bold:11.0"
  label="$CURRENT_ALBUM"
  background.padding_right=235
  opacity=0
)

sketchybar --add item spotify.album popup.spotify \
  --set spotify.album "${spotify_album[@]}" \
  --animate sin_in_out 30

sketchybar --set spotify_label label="$CURRENT_SONG"
