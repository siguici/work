# Contributing

`work` is intentionally small.

Its public interface should remain centered around:

```text
work
work <session_or_workspace>
````

The project should not grow a large collection of commands merely because
Herdr exposes them.

## Design principles

### Simple interface

The primary operation is navigation:

```sh
work
work sikessem
```

### Herdr remains the backend

`work` does not attempt to replace Herdr.

Herdr remains responsible for:

* sessions;
* workspaces;
* tabs;
* panes;
* persistent terminal state.

`work` provides a simpler entry point to those contexts.

### No project-specific assumptions

Do not hard-code:

* personal project names;
* filesystem paths;
* WSL distributions;
* organizations;
* repositories;
* machine-specific configuration.

### Portability

The executable and installer should work on supported Linux environments
without requiring a user's personal configuration.

## Testing

Before submitting a change:

```sh
make check
```

If ShellCheck is installed:

```sh
shellcheck install.sh uninstall.sh
```

Test the executable manually:

```sh
./bin/work
./bin/work --help
./bin/work --version
```

Test installation in a disposable environment when changing the installer.

## Commits

Prefer small, focused commits.

Examples:

```text
feat: add workspace resolution
fix: handle missing herdr
docs: improve installation guide
build: update release workflow
```
