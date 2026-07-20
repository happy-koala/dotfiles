pong() {
    local sound="/System/Library/Sounds/Tink.aiff"
    local sound_start="/System/Library/Sounds/Glass.aiff"
    local sound_fin="/System/Library/Sounds/Sosumi.aiff"
    local show_time=0

    case "$1" in
        start)
            sound="$sound_start"
            shift
            ;;
        fin)
            sound="$sound_fin"
            shift
            ;;
    esac

    case "$1" in
        time|--time)
            show_time=1
            ;;
    esac

    afplay "$sound"
    sleep 2
    blink1 2>/dev/null || true

    if [[ $show_time -eq 1 ]]; then
        printf "\033[1;36m%s\033[0m\n" "$(date)"
    fi
}
