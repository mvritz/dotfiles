#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"
source "$HOME/.config/sketchybar/environment.sh"

ACTIVE_SPACE=$(yabai -m query --spaces --space | jq '.index')

space_bg=(
  background.color="$SPACEBG"
  background.height=19
  background.corner_radius=50
)

for i in "${!SPACE_GHOSTS[@]}"; do
  sid=$(($i + 1))

  if [[ $sid -eq $ACTIVE_SPACE ]]; then
    CURRENT_ICON=$PACMAN
    sketchybar --set space.$sid "${space_bg[@]}"
  else
    CURRENT_ICON=${SPACE_GHOSTS["$i"]}
    sketchybar --set space.$sid background.color="$TRANSPARENT"
  fi

  sketchybar --set space.$sid icon="$CURRENT_ICON"
  sketchybar --set current_space icon="${SPACES[$(($ACTIVE_SPACE - 1))]}"
done
