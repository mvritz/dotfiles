#!/bin/bash

source "$HOME/.config/sketchybar/icons.sh"

# you can get the weather api key from https://openweathermap.org/api
WEATHER_API_KEY="YOUR_API_KEY"

# change the spaces in the order you want them to be displayed or add / remove spaces
# to add icons add them to the icons.sh file
SPACES=("$WORK" "$BROWSER" "$UNI" "$MUSIC" "$MAIL" "$GENERAL")

# for every space you need to set an icon - I recommend the ghosts as they
# match the pacman icon
SPACE_GHOSTS=("$GHOST" "$GHOST" "$GHOST" "$GHOST" "$GHOST" "$GHOST")

# for the sorting button you can set an app (you need the exact app name) and the restrictive
# space number: E.g. APPS="kitty Firefox" and APP_SPACES="1 2" means that the kitty app will be
# sorted into the space 1 and the Firefox app will be sorted into the space 2 when you
# click the sorting button
APPS="kitty IntelliJ WebStorm PyCharm Floorp Notion Obsidian Goodnotes Spotify Mail"
APP_SPACES="1 1 1 1 2 3 3 3 4 5"
