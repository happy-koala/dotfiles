ntfy() {
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        cat <<EOF
=====================
=    ntfy           =
=====================

___  Usage  _________

ntfy
ntfy [title]
ntfy [title] -m [message]
ntfy [title] -t [tag]

___  Options  _______

-m     Set message
-t     Set tag
-h     Show this help
--help Show this help

___  Examples  ______

ntfy
ntfy 'Backup completed'
ntfy 'Backup' -m 'Backup completed successfully'
ntfy 'Backup' -m 'Done' -t tada
EOF
        return 0
    fi

    local url="https://ntfy.sh/${NTFY_TOPIC}"

    local title=""
    local message=""
    local tag=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -m)
                shift
                message="$1"
                ;;
            -t)
                shift
                tag="$1"
                ;;
            *)
                if [[ -z "$title" ]]; then
                    title="$1"
                fi
                ;;
        esac
        shift
    done

    if [[ -z "$title" && -z "$message" ]]; then
        title="task finished"
        message="task finished"
        tag="tada"
    elif [[ -z "$message" ]]; then
        message="$title"
        title="task finished"
        tag="${tag:-information_source}"
    else
        tag="${tag:-tada}"
    fi

    curl -H "Title: $title" \
         -H "Tags: $tag" \
         -d "$message" \
         "$url"
}
