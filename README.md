# botch

<!-- Replace OWNER with your GitHub username after pushing. -->
[![CI](https://github.com/OWNER/botch/actions/workflows/ci.yml/badge.svg)](https://github.com/OWNER/botch/actions/workflows/ci.yml)
[![CD](https://github.com/OWNER/botch/actions/workflows/cd.yml/badge.svg)](https://github.com/OWNER/botch/actions/workflows/cd.yml)

A Godot 4.6 game, built test-first, with CI/CD on GitHub Actions.

**Play:** https://OWNER.github.io/botch/

## Layout

| Path | What goes there |
| --- | --- |
| `src/logic/` | Pure rules/math (`extends RefCounted`), no nodes. Most of the code you TDD lives here. |
| `src/components/` | Thin nodes that forward to `src/logic/`. |
| `test/unit/` | Tests for `src/logic/`. Fast, with no scene tree. |
| `test/integration/` | Nodes/scenes in the tree, with signals and frames. |
| `test/e2e/` | Boots the main scene and drives it with `InputSender`. |

## Running tests

In the editor, use the GUT panel. From a terminal:

```bash
godot --headless -s addons/gut/gut_cmdln.gd
```

To run one layer only, add `-gdir=res://test/unit`.

## Workflow

1. Open an issue. Its acceptance criteria become your tests.
2. Create a branch: `feat/<issue#>-short-name`.
3. Red: write a failing test. Green: make it pass. Refactor. Commit.
4. Open a PR with `Closes #<issue#>`. CI runs lint plus unit, integration and e2e tests.
5. Merge when it's green. Merging to `main` deploys the web build to Pages.
6. Release with `git tag v0.1.0 && git push --tags`. That attaches a Windows build to a GitHub Release.
