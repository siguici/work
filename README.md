# work

> A simple way to get back to where you work.

`work` is a small command-line navigator for [Herdr](https://herdr.dev/).

It gives Herdr a deliberately minimal personal interface:

```text
work
work <session_or_workspace>
````

The idea is simple: **you should only need to remember where you want to work, not how Herdr manages that context.**

## Why work?

Herdr provides persistent terminal sessions, workspaces, tabs, and panes. That makes it a powerful environment for working across multiple projects and contexts.

`work` sits one level above that system.

Instead of remembering whether something is a Herdr session or a workspace, you can simply type:

```sh
work sikessem
```

`work` resolves the name and takes you there.

If you do not provide a name:

```sh
work
```

you get a list of available work contexts and can choose one interactively.

If the name does not exist, `work` tries to recognize a likely typo before offering to create a new context.

## Interface

The public interface is intentionally tiny:

```text
work [<session_or_workspace>]
```

### Open a context

```sh
work sikessem
```

The name is resolved in this order:

1. Herdr session
2. Herdr workspace

A session takes precedence when the same name exists in both places.

### Choose interactively

```sh
work
```

Without an argument, `work` presents the available sessions and workspaces so you can select where to continue working.

### Handle typos

If a context cannot be found:

```sh
work sikessm
```

`work` can display likely matches such as:

```text
No session or workspace named 'sikessm'.

Did you mean?

  1) sikessem

Open one of these? [1/n]:
```

This makes accidentally mistyped context names less disruptive.

If there is no suitable match, `work` can offer to create the requested session or workspace.

## Conceptual model

`work` follows Herdr's hierarchy without exposing unnecessary implementation details:

```text
work
  │
  └── Session
        │
        └── Workspace
              │
              ├── Tab
              │
              └── Pane
```

The distinction is useful:

* **Session** — an independent work universe.
* **Workspace** — a project or concrete work context.
* **Tab** — a view within a workspace.
* **Pane** — an individual terminal or process.

For example:

```text
sikessem
├── Sikessem
├── Loom
├── Ske
├── TransMo
├── Website
└── Documentation

personal
├── Project A
├── Project B
└── Experiments

clients
├── Client A
└── Client B
```

A session is therefore useful for separating major environments, while workspaces organize the projects inside them.

## What work is not

`work` is not another terminal multiplexer.

It does not replace Herdr, tmux, Zellij, or the shell.

It does not manage:

* terminal panes;
* tabs;
* processes;
* Git repositories;
* project configuration;
* environment variables;
* application lifecycle.

Those responsibilities belong to the underlying tools.

`work` only answers one question:

> **Where do I want to work?**

## Requirements

`work` currently targets Linux environments, including WSL.

You need:

* [Herdr](https://herdr.dev/) installed and available as `herdr`;
* a supported `work` executable;
* a POSIX-compatible environment.

For remote installation, you also need either `curl` or `wget`.

## Installation

### Remote installation

Install the latest release:

```sh
curl -fsSL https://raw.githubusercontent.com/siguici/work/main/install.sh | sh
```

Or:

```sh
wget -qO- https://raw.githubusercontent.com/siguici/work/main/install.sh | sh
```

The default installation location is:

```text
~/.local/bin/work
```

Make sure `~/.local/bin` is in your `PATH`.

### Install from a checkout

Clone the repository:

```sh
git clone https://github.com/siguici/work.git
cd work
```

Then:

```sh
./install.sh
```

For an explicit local installation:

```sh
./install.sh --local
```

### Custom installation directory

```sh
WORK_INSTALL_DIR="$HOME/bin" ./install.sh
```

### Specific release

```sh
WORK_VERSION=0.1.0 ./install.sh --remote
```

## Shell completion

`work` provides completion for both Zsh and Bash.

### Zsh

The completion file is:

```text
completions/_work
```

The installer places it in the user's local completion directory.

If necessary, add the directory to `fpath`:

```zsh
fpath=("$HOME/.zfunc" $fpath)

autoload -Uz compinit
compinit
```

### Bash

The completion file is:

```text
completions/work.bash
```

The installer places it in:

```text
~/.local/share/bash-completion/completions/work
```

## Uninstallation

From a local checkout:

```sh
./uninstall.sh
```

Or remotely:

```sh
curl -fsSL https://raw.githubusercontent.com/siguici/work/main/uninstall.sh | sh
```

Uninstallation removes files installed by `work`.

It does **not** remove or modify:

* Herdr;
* Herdr sessions;
* Herdr workspaces;
* terminal processes;
* project files;
* Git repositories;
* user configuration.

## Development

The repository is intentionally small:

```text
work/
├── bin/
│   └── work
├── completions/
│   ├── _work
│   └── work.bash
├── docs/
│   └── INSTALLATION.md
├── .github/
│   └── workflows/
├── .editorconfig
├── .gitignore
├── CONTRIBUTING.md
├── install.sh
├── uninstall.sh
├── LICENSE.md
├── Makefile
├── README.md
└── VERSION
```

The `bin/work` file is the distributed executable.

Run it directly during development:

```sh
./bin/work
```

Check the repository:

```sh
make check
```

## Design principles

### Minimal interface

The main interface should remain:

```text
work [<session_or_workspace>]
```

Additional functionality should not unnecessarily turn `work` into a large command hierarchy.

### Context-oriented

The user thinks in terms of work contexts:

```text
sikessem
ske
loom
clients
personal
```

`work` should handle the underlying Herdr terminology.

### Forgiving

A typo should not immediately result in a dead end.

When possible, `work` should suggest the closest existing context before asking the user to create something new.

### Portable

The tool should be usable on another machine without copying a personal shell configuration.

No project names, directories, organizations, or machine-specific paths are hard-coded into the tool.

### Herdr-first

`work` complements Herdr rather than competing with it.

Herdr remains responsible for persistent terminal state and workspace management.

## License

`work` is released under the [MIT License](LICENSE.md).
