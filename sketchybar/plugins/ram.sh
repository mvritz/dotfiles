#!/bin/sh

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"

RAM=$(vm_stat | awk '/Pages free:/ {free=$3} /Pages active:/ {active=$3} /Pages inactive:/ {inactive=$3} /Pages speculative:/ {speculative=$3} END {total=free + active + inactive + speculative; used=active + inactive; print int(100*used/total)}')

sketchybar --set $NAME label="$RAM%"