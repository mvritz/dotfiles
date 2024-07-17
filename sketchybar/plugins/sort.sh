#!/bin/bash

source "$HOME/.config/sketchybar/environment.sh"

move_app_to_space() {
    local app_name=$1
    local space_id=$2
    local window_id=$(yabai -m query --windows | jq ".[] | select(.app == \"$app_name\") | .id")

    if [[ -n "$window_id" ]]; then
        yabai -m window "$window_id" --space "$space_id"
        echo "Moved $app_name to space $space_id."
    else
        echo "No windows found for $app_name."
    fi
}

IFS=' ' read -r -a app_array <<< "$APPS"
IFS=' ' read -r -a space_array <<< "$APP_SPACES"

if [[ ${#app_array[@]} -eq ${#space_array[@]} ]]; then
    for i in "${!app_array[@]}"; do
        move_app_to_space "${app_array[i]}" "${space_array[i]}"
    done
else
    osascript -e 'display notification "App and space arrays are not the same length" with title "Error"'
    exit 1
fi

osascript -e 'display notification "All spaces sorted successfully" with title "Sorting complete"'
