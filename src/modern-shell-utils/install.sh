#!/usr/bin/env bash
set -euo pipefail

echo "Activating feature 'modern-shell-utils'"

echo "Step 1, check for root privileges"
if [ "$(id -u)" -ne 0 ]; then
    echo "This feature must be installed as root." >&2
    exit 1
fi

echo "Step 2, check the distribution"
. /etc/os-release
if ! { [[ "${ID}" == "debian" ]] && dpkg --compare-versions "${VERSION_ID}" ge 13; } &&
   ! { [[ "${ID}" == "ubuntu" ]] && dpkg --compare-versions "${VERSION_ID}" ge 24.04; }; then
    echo "Unsupported distribution: ${PRETTY_NAME}. This feature requires Debian 13+ or Ubuntu 24.04+." >&2
    exit 1
fi

export DEBIAN_FRONTEND=noninteractive
echo "Step 3, refresh package indexes"
rm -rf /var/lib/apt/lists/*
apt-get update -y

if ! apt-cache show eza >/dev/null 2>&1; then
    echo "eza is unavailable from the configured APT sources. Enable the distribution's eza package repository." >&2
    exit 1
fi

echo "Step 4, install eza, fd, ripgrep, and bat"
apt-get install -y --no-install-recommends eza fd-find ripgrep bat

echo "Step 5, expose fd, bat, and ag commands"
if ! command -v fd >/dev/null 2>&1; then
    ln -sfn /usr/bin/fdfind /usr/local/bin/fd
fi
if ! command -v bat >/dev/null 2>&1; then
    ln -sfn /usr/bin/batcat /usr/local/bin/bat
fi
if ! command -v ag >/dev/null 2>&1; then
    ln -sfn /usr/bin/rg /usr/local/bin/ag
fi

echo "Step 6, clean up"
rm -rf /var/lib/apt/lists/*
echo "Done!"
