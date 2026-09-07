#!/usr/bin/env sh

set -eu

REPOSITORY="siguici/work"
INSTALL_DIR="${WORK_INSTALL_DIR:-${HOME}/.local/bin}"
VERSION="${WORK_VERSION:-latest}"

log() {
    printf '%s\n' "work: $*"
}

error() {
    printf '%s\n' "work: $*" >&2
    exit 1
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

require_download_tool() {
    if command_exists curl || command_exists wget; then
        return 0
    fi

    error "curl or wget is required"
}

download() {
    url="$1"
    destination="$2"

    if command_exists curl; then
        curl -fsSL "$url" -o "$destination"
        return
    fi

    wget -qO "$destination" "$url"
}

detect_platform() {
    os="$(uname -s)"
    arch="$(uname -m)"

    case "$os" in
        Linux)
            platform="linux"
            ;;
        *)
            error "unsupported operating system: $os"
            ;;
    esac

    case "$arch" in
        x86_64|amd64)
            architecture="x86_64"
            ;;
        aarch64|arm64)
            architecture="aarch64"
            ;;
        *)
            error "unsupported architecture: $arch"
            ;;
    esac

    BINARY_NAME="work-${platform}-${architecture}"
}

local_install() {
    script_dir=$(
        CDPATH= cd -- "$(dirname -- "$0")" >/dev/null 2>&1
        pwd
    )

    source="${script_dir}/bin/work"

    if [ ! -f "$source" ]; then
        error "local binary not found: ${source}"
    fi

    mkdir -p "$INSTALL_DIR"

    install -m 0755 "$source" "${INSTALL_DIR}/work"

    log "installed ${INSTALL_DIR}/work"
}

remote_install() {
    require_download_tool
    detect_platform

    temporary_directory="$(mktemp -d)"

    cleanup() {
        rm -rf "$temporary_directory"
    }

    trap cleanup EXIT INT TERM

    if [ "$VERSION" = "latest" ]; then
        release_url="https://github.com/${REPOSITORY}/releases/latest/download/${BINARY_NAME}"
    else
        release_url="https://github.com/${REPOSITORY}/releases/download/v${VERSION}/${BINARY_NAME}"
    fi

    temporary_binary="${temporary_directory}/work"

    log "downloading ${BINARY_NAME}..."
    download "$release_url" "$temporary_binary"

    chmod 0755 "$temporary_binary"

    mkdir -p "$INSTALL_DIR"
    install -m 0755 "$temporary_binary" "${INSTALL_DIR}/work"

    log "installed ${INSTALL_DIR}/work"
}

install_zsh_completion() {
    source="$1"

    [ -f "$source" ] || return 0

    if [ -n "${ZDOTDIR:-}" ]; then
        directory="${ZDOTDIR}/.zfunc"
    else
        directory="${HOME}/.zfunc"
    fi

    mkdir -p "$directory"
    install -m 0644 "$source" "${directory}/_work"

    log "installed Zsh completion"
}

install_bash_completion() {
    source="$1"

    [ -f "$source" ] || return 0

    directory="${HOME}/.local/share/bash-completion/completions"

    mkdir -p "$directory"
    install -m 0644 "$source" "${directory}/work"

    log "installed Bash completion"
}

install_local_completions() {
    script_dir=$(
        CDPATH= cd -- "$(dirname -- "$0")" >/dev/null 2>&1
        pwd
    )

    install_zsh_completion "${script_dir}/completions/_work"
    install_bash_completion "${script_dir}/completions/work.bash"
}

install_remote_completions() {
    require_download_tool

    temporary_directory="$(mktemp -d)"

    cleanup() {
        rm -rf "$temporary_directory"
    }

    trap cleanup EXIT INT TERM

    base_url="https://raw.githubusercontent.com/${REPOSITORY}/main/completions"

    zsh_completion="${temporary_directory}/_work"
    bash_completion="${temporary_directory}/work.bash"

    download "${base_url}/_work" "$zsh_completion"
    download "${base_url}/work.bash" "$bash_completion"

    install_zsh_completion "$zsh_completion"
    install_bash_completion "$bash_completion"
}

main() {
    case "${1:-}" in
        --local)
            local_install
            install_local_completions
            ;;

        --remote)
            remote_install
            install_remote_completions
            ;;

        --help|-h)
            cat <<'EOF'
Usage:
  install.sh
  install.sh --local
  install.sh --remote

Environment:
  WORK_INSTALL_DIR
      Installation directory.
      Default: ~/.local/bin

  WORK_VERSION
      Release version to install.
      Default: latest

Examples:

  ./install.sh

  ./install.sh --local

  WORK_VERSION=0.1.0 ./install.sh --remote

Remote installation:

  curl -fsSL https://raw.githubusercontent.com/siguici/work/main/install.sh | sh
EOF
            ;;

        "")
            if [ -f "$(dirname "$0")/bin/work" ]; then
                local_install
                install_local_completions
            else
                remote_install
                install_remote_completions
            fi
            ;;

        *)
            error "unknown option: $1"
            ;;
    esac

    log "done"
}

main "$@"
