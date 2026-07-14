#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

ITEM="${NAME:-front_app}"
STATE_DIR="${TMPDIR:-/tmp}/sketchybar-pacman"
CONTEXT_FILE="$STATE_DIR/front-context"
mkdir -p "$STATE_DIR"

run_with_timeout() {
  local seconds="$1"
  shift
  /usr/bin/perl -e '$seconds = shift @ARGV; alarm $seconds; exec @ARGV' "$seconds" "$@"
}

run_osascript() {
  run_with_timeout 1 /usr/bin/osascript -e "$1" 2>/dev/null
}

codex_chat_title() {
  local thread_id="" title=""
  local logs_db="$HOME/.codex/logs_2.sqlite"
  local state_db="$HOME/.codex/state_5.sqlite"
  local session_index="$HOME/.codex/session_index.jsonl"

  [[ -r "$session_index" ]] || return 1

  if [[ -r "$logs_db" ]]; then
    thread_id="$(run_with_timeout 1 /usr/bin/sqlite3 -readonly "$logs_db" \
      "SELECT thread_id FROM logs WHERE thread_id IS NOT NULL ORDER BY ts DESC, ts_nanos DESC LIMIT 1;" 2>/dev/null)"
  fi

  if [[ -z "$thread_id" && -r "$state_db" ]]; then
    thread_id="$(run_with_timeout 1 /usr/bin/sqlite3 -readonly "$state_db" \
      "SELECT id FROM threads WHERE archived=0 ORDER BY recency_at_ms DESC LIMIT 1;" 2>/dev/null)"
  fi

  if [[ -n "$thread_id" ]]; then
    title="$(/opt/homebrew/bin/jq -r --arg id "$thread_id" \
      'select(.id == $id) | .thread_name // empty' "$session_index" 2>/dev/null | /usr/bin/tail -n 1)"
  fi

  if [[ -z "$title" ]]; then
    title="$(/usr/bin/tail -n 1 "$session_index" 2>/dev/null \
      | /opt/homebrew/bin/jq -r '.thread_name // empty' 2>/dev/null)"
  fi

  printf '%s' "$title"
}

clean_text() {
  printf '%s' "$1" | /usr/bin/tr '\n\r\t' '   ' | /usr/bin/sed -E 's/[[:space:]]+/ /g; s/^ //; s/ $//'
}

shorten() {
  local value="$1"
  local limit="${2:-48}"
  if (( ${#value} > limit )); then
    printf '%s…' "${value:0:$((limit - 1))}"
  else
    printf '%s' "$value"
  fi
}

kitty_process_command() {
  local kitty_pid="$1"
  /bin/ps -axo pid=,ppid=,state=,comm=,args= | /usr/bin/awk -v root="$kitty_pid" '
    {
      pid=$1; parent[pid]=$2; state[pid]=$3; command[pid]=$4
      args=""
      for (i=5; i<=NF; i++) args=args (i==5 ? "" : " ") $i
      argv[pid]=args
    }
    END {
      best=0
      for (pid in parent) {
        cur=pid; guard=0
        while (cur != root && parent[cur] != "" && guard++ < 50) cur=parent[cur]
        if (cur != root || pid == root || state[pid] ~ /Z/) continue
        base=command[pid]
        sub(/^.*\//, "", base); sub(/^-/, "", base)
        if (base ~ /^(kitty|kitten|login|zsh|bash|fish|sh)$/) continue
        if (argv[pid] ~ /kitty\.app\/Contents\/MacOS\/kitten (__atexit__|run-shell)/) continue
        if ((pid + 0) > (best + 0)) { best=pid; result=argv[pid] }
      }
      print result
    }'
}

WINDOW_JSON="$(/opt/homebrew/bin/yabai -m query --windows --window 2>/dev/null)"
APP="$(printf '%s' "$WINDOW_JSON" | /opt/homebrew/bin/jq -r '.app // empty' 2>/dev/null)"
TITLE="$(printf '%s' "$WINDOW_JSON" | /opt/homebrew/bin/jq -r '.title // empty' 2>/dev/null)"
WINDOW_PID="$(printf '%s' "$WINDOW_JSON" | /opt/homebrew/bin/jq -r '.pid // empty' 2>/dev/null)"
[[ -n "$APP" ]] || APP="Desktop"

DISPLAY_APP="$APP"
RAW_DETAIL=""
URL=""

case "$APP" in
  Arc)
    URL="$(run_osascript 'tell application "Arc" to get URL of active tab of front window')"
    ;;
  Safari)
    URL="$(run_osascript 'tell application "Safari" to get URL of current tab of front window')"
    ;;
  "Google Chrome")
    DISPLAY_APP="Chrome"
    URL="$(run_osascript 'tell application "Google Chrome" to get URL of active tab of front window')"
    ;;
  "Microsoft Edge")
    DISPLAY_APP="Edge"
    URL="$(run_osascript 'tell application "Microsoft Edge" to get URL of active tab of front window')"
    ;;
  "Brave Browser")
    DISPLAY_APP="Brave"
    URL="$(run_osascript 'tell application "Brave Browser" to get URL of active tab of front window')"
    ;;
  kitty|Kitty)
    DISPLAY_APP="Kitty"
    KITTY_BIN="/Applications/kitty.app/Contents/MacOS/kitty"
    KITTY_SOCKET="/tmp/sketchybar-kitty-${WINDOW_PID}"
    if [[ -x "$KITTY_BIN" && -S "$KITTY_SOCKET" ]]; then
      KITTY_JSON="$(run_with_timeout 1 "$KITTY_BIN" @ --to "unix:$KITTY_SOCKET" ls 2>/dev/null)"
      COMMAND="$(printf '%s' "$KITTY_JSON" | /opt/homebrew/bin/jq -r '
        [.[].tabs[].windows[] | select(.is_focused == true)][0]
        | (.foreground_processes // []) as $processes
        | if ($processes | length) > 0 then ($processes[-1].cmdline // [] | join(" ")) else empty end' 2>/dev/null)"
    fi
    if [[ -z "$COMMAND" && "$WINDOW_PID" =~ ^[0-9]+$ ]]; then COMMAND="$(kitty_process_command "$WINDOW_PID")"; fi
    FIRST_WORD="${COMMAND%% *}"
    COMMAND_NAME="${FIRST_WORD##*/}"
    COMMAND_NAME="${COMMAND_NAME#-}"
    case "$COMMAND_NAME" in
      ""|zsh|bash|fish|sh|login) RAW_DETAIL="Home" ;;
      *) RAW_DETAIL="$COMMAND" ;;
    esac
    ;;
  ChatGPT|Codex)
    DISPLAY_APP="Codex"
    RAW_DETAIL="$(codex_chat_title)"
    ;;
  Spotify)
    RAW_DETAIL="$(run_osascript 'tell application "Spotify"
      if it is running then return (name of current track) & " — " & (artist of current track)
    end tell')"
    ;;
  Mail)
    RAW_DETAIL="$(run_osascript 'tell application "Mail"
      if it is running then
        if (count of selection) > 0 then return subject of item 1 of selection
        try
          set selectedBoxes to selected mailboxes of message viewer 1
          if (count of selectedBoxes) > 0 then return name of item 1 of selectedBoxes
        end try
      end if
    end tell')"
    ;;
  Code)
    DISPLAY_APP="VS Code"
    ;;
esac

if [[ "$URL" == *"://"* ]]; then
  HOST="${URL#*://}"
  HOST="${HOST%%/*}"
  HOST="${HOST##*@}"
  HOST="${HOST%%:*}"
  HOST="${HOST#www.}"
  [[ -n "$HOST" ]] && RAW_DETAIL="$HOST"
fi

if [[ -z "$RAW_DETAIL" && -n "$TITLE" && "$TITLE" != "$APP" && "$TITLE" != "$DISPLAY_APP" ]]; then RAW_DETAIL="$TITLE"; fi

DISPLAY_APP="$(shorten "$(clean_text "$DISPLAY_APP")" 20)"
RAW_DETAIL="$(shorten "$(clean_text "$RAW_DETAIL")" 48)"
[[ -n "$DISPLAY_APP" ]] || DISPLAY_APP="Desktop"

if [[ -n "$RAW_DETAIL" ]]; then
  DETAIL="› $RAW_DETAIL"
  ICON_LEFT=11; ICON_RIGHT=6; LABEL_RIGHT=11
else
  DETAIL=""
  ICON_LEFT=11; ICON_RIGHT=11; LABEL_RIGHT=0
fi

CONTEXT="$DISPLAY_APP|$DETAIL"
PREVIOUS_CONTEXT="$(/bin/cat "$CONTEXT_FILE" 2>/dev/null)"
[[ "$CONTEXT" == "$PREVIOUS_CONTEXT" ]] && exit 0
printf '%s\n' "$CONTEXT" > "$CONTEXT_FILE"

sketchybar --animate tanh 4 \
  --set "$ITEM" icon.color="$APP_FADE" label.color="$APP_FADE" icon.y_offset=-2 label.y_offset=-2 \
    background.border_color="$TOKYO_EVENT" background.color="$TOKYO_HOVER"
sleep 0.045

sketchybar --set "$ITEM" icon="$DISPLAY_APP" label="$DETAIL" \
    icon.padding_left="$ICON_LEFT" icon.padding_right="$ICON_RIGHT" \
    label.padding_left=0 label.padding_right="$LABEL_RIGHT" \
  --animate sin 9 \
  --set "$ITEM" icon.color="$TOKYO_BLUE" label.color="$TOKYO_MUTED" icon.y_offset=0 label.y_offset=0 \
    background.border_color="$TOKYO_BORDER" background.color="$TOKYO_SURFACE"
