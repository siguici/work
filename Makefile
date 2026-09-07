PREFIX ?= $(HOME)/.local
BINDIR ?= $(PREFIX)/bin

.PHONY: check install uninstall

check:
	@test -x bin/work
	@test -f completions/_work
	@test -f completions/work.bash
	@test -f install.sh
	@test -f uninstall.sh
	@if command -v shellcheck >/dev/null 2>&1; then \
		shellcheck install.sh uninstall.sh; \
	else \
		echo "shellcheck not installed; skipping shellcheck"; \
	fi

install:
	WORK_INSTALL_DIR="$(BINDIR)" ./install.sh --local

uninstall:
	WORK_INSTALL_DIR="$(BINDIR)" ./uninstall.sh
````
