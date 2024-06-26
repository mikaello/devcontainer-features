# A Dev Container Features Collection

This repository is based on the
[the `devcontainers/features` repository](https://github.com/devcontainers/features).

## Contents

### [`modern-shell-utils`](src/modern-shell-utils/README.md)

Install the modern shell utilities:

- [eza](https://eza.rocks/), _ls_ alternative (previously [exa](https://github.com/ogham/exa) was bundled)
- [fd](https://github.com/sharkdp/fd), _find_ alternative
- [ag (The Silver Seacher)](https://github.com/ggreer/the_silver_searcher),
  _grep_ alternative
- [bat](https://github.com/sharkdp/bat), _cat_ alternative

### [`kotlinc`](src/kotlinc/README.md)

Install _kotlinc_ and [_ktlint_](https://github.com/pinterest/ktlint).

**NB.** requires Java to work. Either use a base image with Java or add feature
`ghcr.io/devcontainers/features/java:1`.
