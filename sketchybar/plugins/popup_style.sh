#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# Shared shadcn-inspired popup primitives: one panel, flat rows, aligned icon columns.
POPUP_ROW=(
  width=208
  padding_left=4
  padding_right=4
  icon.font="SF Pro:Medium:11.5"
  icon.color="$TOKYO_MUTED"
  icon.width=22
  icon.align=center
  icon.padding_left=7
  icon.padding_right=6
  icon.background.drawing=off
  label.font="SF Pro:Medium:11.5"
  label.color="$TOKYO_MUTED"
  label.padding_left=0
  label.padding_right=10
  label.max_chars=30
  background.drawing=on
  background.color="$TOKYO_POPUP_ROW"
  background.height=28
  background.corner_radius=7
  background.border_width=0
  background.border_color="$TRANSPARENT"
  blur_radius=0
)

POPUP_HEADER=(
  "${POPUP_ROW[@]}"
  background.height=28
  icon.color="$TOKYO_CYAN"
  label.font="SF Pro:Semibold:12.5"
  label.color="$TOKYO_FG"
)

POPUP_META=(
  "${POPUP_ROW[@]}"
  label.font="SF Pro:Medium:10.5"
  label.color="$TOKYO_MUTED"
  icon.color="$TOKYO_COMMENT"
)

POPUP_ACTION=(
  "${POPUP_ROW[@]}"
  label.color="$TOKYO_FG"
  icon.color="$TOKYO_MUTED"
)

POPUP_HERO=(
  "${POPUP_HEADER[@]}"
  label.font="SF Pro:Bold:15.0"
)

POPUP_SECTION=(
  "${POPUP_ROW[@]}"
  icon.drawing=off
  label.font="SF Pro:Semibold:9.5"
  label.color="$TOKYO_COMMENT"
  label.padding_left=10
  label.max_chars=34
  background.height=24
)
