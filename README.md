# A Dev Container Features Collection

This repository is based on the
[`devcontainers/features` repository](https://github.com/devcontainers/features).

## Contents

### [`modern-shell-utils`](src/modern-shell-utils/README.md)

Install the modern shell utilities:

- [eza](https://eza.rocks/), _ls_ alternative (previously [exa](https://github.com/ogham/exa) was bundled)
- [fd](https://github.com/sharkdp/fd), _find_ alternative
- [ripgrep](https://github.com/BurntSushi/ripgrep), _grep_ alternative
- [bat](https://github.com/sharkdp/bat), _cat_ alternative

`ag` remains available as a compatibility command for basic searches and runs `rg`.
Some `ag` options behave differently.

### [`kotlinc`](src/kotlinc/README.md)

Install _kotlinc_ and [_ktlint_](https://github.com/ktlint/ktlint).

**NB.** requires Java to work. Either use a base image with Java or add feature
`ghcr.io/devcontainers/features/java:1`.
