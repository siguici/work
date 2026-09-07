#!/usr/bin/env sh

set -eu

INSTALL_DIR="${WORK_INSTALL_DIR:-${HOME}/.local/bin}"

log() {
    printf '%s\n' "work: $*"
}

remove_if_exists() {
    file="$1"

    if [ -e "$file" ]; then
        rm -f "$file"
        log "removed ${file}"
    fi
}

main() {
    remove_if_exists "${INSTALL_DIR}/work"

    if [ -n "${ZDOTDIR:-}" ]; then
        remove_if_exists "${ZDOTDIR}/.zfunc/_work"
    fi

    remove_if_exists "${HOME}/.zfunc/_work"
    remove_if_exists "${HOME}/.local/share/bash-completion/completions/work"

    log "work has been uninstalled"
    log "Herdr sessions and workspaces were not modified"
}

main "$@"
