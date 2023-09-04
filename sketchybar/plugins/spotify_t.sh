#!/bin/sh

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"

spotify_cover=(
  script="$PLUGIN_DIR/spotify_util.sh"
  click_script="open -a 'Spotify'; $POPUP_SCRIPT"
  label.drawing=off
  icon.drawing=off
  padding_left=12
  padding_right=10
  background.image.scale=0.2
  background.image.drawing=on
  background.drawing=on
)

sketchybar --add item spotify.cover popup.spotify \
  --set spotify.cover "${spotify_cover[@]}"

spotify_title=(
  icon.drawing=off
  padding_left=0
  padding_right=0
  width=0
  label.font="SF Pro:Bold:16.0"
  y_offset=55
)

sketchybar --add item spotify.title popup.spotify \
  --set spotify.title "${spotify_title[@]}"

spotify_artist=(
  icon.drawing=off
  y_offset=30
  padding_left=0
  padding_right=0
  width=0
)

sketchybar --add item spotify.artist popup.spotify.anchor \
  --set spotify.artist "${spotify_artist[@]}"

spotify_album=(
  icon.drawing=off
  padding_left=0
  padding_right=0
  y_offset=15
  width=0
)

sketchybar --add item spotify.album popup.spotify \
  --set spotify.album "${spotify_album[@]}"
