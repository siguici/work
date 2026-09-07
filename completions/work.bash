_work_completion() {
    local current_word
    current_word="${COMP_WORDS[COMP_CWORD]}"

    if [ "${COMP_CWORD}" -gt 1 ]; then
        return 0
    fi

    local contexts

    contexts="$(work --completion-bash 2>/dev/null)" || return 0

    COMPREPLY=(
        $(compgen -W "${contexts}" -- "${current_word}")
    )
}

complete -F _work_completion work
