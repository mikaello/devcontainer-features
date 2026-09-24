
# Modern shell utils (modern-shell-utils)

eza, fd, ripgrep, and bat for Debian 13+ and Ubuntu 24.04+

## Example Usage

```json
"features": {
    "ghcr.io/mikaello/devcontainer-features/modern-shell-utils:3": {}
}
```



# modern-shell-utils v3

Replaced The Silver Searcher with the maintained `rg` from ripgrep.
An `ag` command points to `rg` for simple searches; some flags and output differ.
Requires Debian 13+ or Ubuntu 24.04+ with the distribution's `eza` package available.

## Previous changes

Replaced [`exa`](https://github.com/ogham/exa) with [`eza`](https://github.com/eza-community/eza) due to `exa` being deprecated.


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/mikaello/devcontainer-features/blob/main/src/modern-shell-utils/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
