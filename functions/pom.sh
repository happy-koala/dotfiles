pom() {

  local white=$'\033[37m'
  local green=$'\033[32m'
  local reset=$'\033[0m'

  if [[ "$1" == "-h" || "$1" == "--help" || "$1" == "help" ]]; then
    cat <<EOF
=====================
=    pom            =
=====================

___  Usage  _________

pom
pom [work_duration] [pause_duration]
pom -h
pom --help
pom help

___  Arguments  _____

work_duration   Work duration in minutes (default: 45)
pause_duration  Pause duration in minutes (default: 10)

If only one duration is provided, it is used as work_duration.
pause_duration remains at its default value.

___  Examples  ______

pom
pom 25
pom 25 5

Every third work cycle is followed by a pause three times as long.

EOF
    return
  fi

  if [[ $# -gt 2 || ! "$1" =~ ^[0-9]+$ && -n "$1" || ! "$2" =~ ^[0-9]+$ && -n "$2" ]]; then
    cat <<EOF
Invalid arguments.

Use 'pom --help' for usage information.
EOF
    return 1
  fi

  local work_duration=${1:-45}
  local pause_duration=${2:-10}
  local cycle=1

  progress_bar() {
    local duration=$(( $1 * 60 ))
    local terminal_width
    terminal_width=$(tput cols)

    local bar_length=$((terminal_width - 10))

    if ((bar_length < 10)); then
      bar_length=10
    fi

    local step_duration=$((duration / bar_length))

    if ((step_duration < 1)); then
      step_duration=1
    fi

    echo -ne "\r${white}$(printf '|%.0s' $(seq 1 "$bar_length"))${reset}"

    for ((i = 1; i <= bar_length; i++)); do
      local progress_length=$i
      local remaining_length=$((bar_length - progress_length))
      local progress="${green}$(printf '|%.0s' $(seq 1 "$progress_length"))"

      if ((remaining_length > 0)); then
        progress+="${white}$(printf '|%.0s' $(seq 1 "$remaining_length"))"
      fi

      progress+="${reset}"

      echo -ne "\r$progress"

      if ((i < bar_length)); then
        sleep "$step_duration"
      fi
    done

    echo
  }

  while true; do
    echo "=== WORK (${work_duration} min) | Runde $cycle ==="

    progress_bar "$work_duration"

    if ((cycle > 1)); then
      ntfy Pomodoro -m Work -t arrow_forward
      pong start --time
    fi

    if ((cycle % 3 == 0)); then
      local current_pause=$((pause_duration * 3))
    else
      local current_pause=$pause_duration
    fi

    echo "=== PAUSE (${current_pause} min) ==="

    ntfy Pomodoro -m Pause -t pause_button
    pong fin --time
    progress_bar "$current_pause"

    ((cycle++))
  done
}
