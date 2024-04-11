#!/bin/sh

kitty=$(yabai -m query --windows | jq '.[] | select(.app == "kitty") | .id')
yabai -m window "$kitty" --space 1

IntelliJ=$(yabai -m query --windows | jq '.[] | select(.app == "IntelliJ") | .id')
yabai -m window "$IntelliJ" --space 1

WebStorm=$(yabai -m query --windows | jq '.[] | select(.app == "WebStorm") | .id')
yabai -m window "$WebStorm" --space 1

PyCharm=$(yabai -m query --windows | jq '.[] | select(.app == "PyCharm") | .id')
yabai -m window "$PyCharm" --space 1

SigmaOS=$(yabai -m query --windows | jq '.[] | select(.app == "SigmaOS") | .id')
yabai -m window "$SigmaOS" --space 2

OperaGX=$(yabai -m query --windows | jq '.[] | select(.app == "Opera GX") | .id')
yabai -m window "$OperaGX" --space 2

Notion=$(yabai -m query --windows | jq '.[] | select(.app == "Notion") | .id')
yabai -m window "$Notion" --space 3

Goodnotes=$(yabai -m query --windows | jq '.[] | select(.app == "Goodnotes") | .id')
yabai -m window "$Goodnotes" --space 3

Spotify=$(yabai -m query --windows | jq '.[] | select(.app == "Spotify") | .id')
yabai -m window "$Spotify" --space 4

Mail=$(yabai -m query --windows | jq '.[] | select(.app == "Mail") | .id')
yabai -m window "$Mail" --space 5

