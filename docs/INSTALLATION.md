# Installation

`work` is distributed as a native executable and can be installed either from
a local checkout or from a GitHub release.

## Requirements

- Linux
- x86_64 or ARM64
- Herdr
- `curl` or `wget` for remote installation

## Local installation

Clone the repository:

```sh
git clone https://github.com/siguici/work.git
cd work
````

Then:

```sh
./install.sh
```

The executable is installed to:

```text
~/.local/bin/work
```

## Remote installation

Install the latest release:

```sh
curl -fsSL https://raw.githubusercontent.com/siguici/work/main/install.sh | sh
```

Or:

```sh
wget -qO- https://raw.githubusercontent.com/siguici/work/main/install.sh | sh
```

## Installing a specific version

```sh
WORK_VERSION=0.1.0 ./install.sh --remote
```

## Custom installation directory

```sh
WORK_INSTALL_DIR="$HOME/bin" ./install.sh
```

## Shell completion

Zsh completion is installed under:

```text
~/.zfunc/_work
```

Bash completion is installed under:

```text
~/.local/share/bash-completion/completions/work
```

For Zsh, ensure that the completion directory is part of `fpath` before
`compinit`:

```zsh
fpath=("$HOME/.zfunc" $fpath)
autoload -Uz compinit
compinit
```

## Verify installation

```sh
command -v work
work --version
```

Then:

```sh
work
```

## Uninstallation

From the repository:

```sh
./uninstall.sh
```

Or remotely:

```sh
curl -fsSL https://raw.githubusercontent.com/siguici/work/main/uninstall.sh | sh
```

Uninstallation only removes files installed by `work`.

It does not remove:

- Herdr;
- Herdr sessions;
- Herdr workspaces;
- project files;
- shell configuration;
- user data.
