#!/bin/sh

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"

SPOTIFY_EVENT="com.spotify.client.PlaybackStateChanged"
POPUP_SCRIPT="sketchybar -m --set spotify.anchor popup.drawing=toggle"
PLUGIN_DIR="$HOME/.config/sketchybar/plugins"

spotify_anchor=(
  script="$PLUGIN_DIR/spotify_util.sh"
  click_script="$POPUP_SCRIPT"
  popup.horizontal=on
  popup.align=center
  popup.height=150
  icon=$SPOTIFY
  icon.padding_right=15
  icon.padding_left=15
  background.corner_radius=10
  background.color=$TEMPUS
  background.height=19
  background.padding_left=3
  background.padding_right=-6
  background.border_color=$PURPLE
)

sketchybar --add event spotify_change $SPOTIFY_EVENT \
  --add item spotify.anchor e \
  --set spotify.anchor "${spotify_anchor[@]}" \
  --subscribe spotify.anchor mouse.entered mouse.exited \
  mouse.exited.global

spotify_label=(
  label="Spotify"
  label.padding_left=15
  label.padding_right=15
  label.font="SF Pro:Bold:9.0"
  script="$PLUGIN_DIR/spotify_util.sh"
  click_script="open -a Spotify"
)

sketchybar --add item spotify.label e \
  --set spotify.label "${spotify_label[@]}"

spotify_view=(
  background.border_color=$PURPLE
  background.border_width=3
  background.corner_radius=10
  background.color=$STATUS
  background.height=25
)

sketchybar --add bracket spotify.view spotify.anchor spotify.label e \
  --set spotify.view "${spotify_view[@]}"

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

sketchybar --add item spotify.cover popup.spotify.anchor \
  --set spotify.cover "${spotify_cover[@]}"

spotify_title=(
  icon.drawing=off
  padding_left=0
  padding_right=0
  width=0
  label.font="SF Pro:Bold:15.0"
  y_offset=55
)

sketchybar --add item spotify.title popup.spotify.anchor \
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

sketchybar --add item spotify.album popup.spotify.anchor \
  --set spotify.album "${spotify_album[@]}"

spotify_state=(
  icon.drawing=on
  icon.font="SF Pro:Regular:10.0"
  icon.width=35
  icon="00:00"
  label.drawing=on
  label.font="SF Pro:Regular:10.0"
  label.width=35
  label="00:00"
  label.padding_left=5
  y_offset=-15
  width=17
  slider.background.height=7
  slider.background.corner_radius=30
  slider.background.color=$WHITE
  slider.background.border_color=$PURPLE
  slider.background.border_width=1
  slider.highlight_color=$PURPLE
  slider.percentage=40
  slider.width=115
  script="$PLUGIN_DIR/spotify_util.sh"
  update_freq=1
  updates=when_shown
)

sketchybar --add slider spotify.state popup.spotify.anchor \
  --set spotify.state "${spotify_state[@]}" \
  --subscribe spotify.state mouse.clicked

spotify_shuffle=(
  icon=$SHUFFLE
  icon.padding_left=25
  icon.padding_right=5
  icon.highlight_color=$PURPLE
  label.drawing=off
  script="$PLUGIN_DIR/spotify_util.sh"
  y_offset=-45
)

sketchybar --add item spotify.shuffle popup.spotify.anchor \
  --set spotify.shuffle "${spotify_shuffle[@]}" \
  --subscribe spotify.shuffle mouse.clicked

spotify_back=(
  icon=$BACKWARD
  icon.padding_left=5
  icon.padding_right=5
  script="$PLUGIN_DIR/spotify_util.sh"
  label.drawing=off
  y_offset=-45
)

sketchybar --add item spotify.back popup.spotify.anchor \
  --set spotify.back "${spotify_back[@]}" \
  --subscribe spotify.back mouse.clicked

spotify_play=(
  background.height=40
  background.corner_radius=20
  width=40
  align=center
  background.color=$PURPLE
  background.border_color=$WHITE
  background.border_width=0
  background.drawing=on
  icon.padding_left=4
  icon.padding_right=5
  updates=on
  label.drawing=off
  script="$PLUGIN_DIR/spotify_util.sh"
  y_offset=-45
)

sketchybar --add item spotify.play popup.spotify.anchor \
  --set spotify.play "${spotify_play[@]}" \
  --subscribe spotify.play mouse.clicked spotify_change

spotify_next=(
  icon=$FORWARD
  icon.padding_left=5
  icon.padding_right=5
  label.drawing=off
  script="$PLUGIN_DIR/spotify_util.sh"
  y_offset=-45
)

sketchybar --add item spotify.next popup.spotify.anchor \
  --set spotify.next "${spotify_next[@]}" \
  --subscribe spotify.next mouse.clicked

spotify_repeat=(
  icon=$REPEAT
  icon.highlight_color=$PURPLE
  icon.padding_left=5
  icon.padding_right=10
  label.drawing=off
  script="$PLUGIN_DIR/spotify_util.sh"
  y_offset=-45
)

sketchybar --add item spotify.repeat popup.spotify.anchor \
  --set spotify.repeat "${spotify_repeat[@]}" \
  --subscribe spotify.repeat mouse.clicked

sketchybar -add item spotify.space popup.spotify.anchor \
  --set spotify.space width=5
