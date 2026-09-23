#!/usr/bin/env bash
set -euo pipefail

echo "Activating feature 'kotlinc'"

echo "Step 1, check for root privileges"
if [ "$(id -u)" -ne 0 ]; then
    echo "This feature must be installed as root." >&2
    exit 1
fi

. /etc/os-release
echo "Step 2, check the distribution"
if [[ "${ID}" != "debian" && "${ID}" != "ubuntu" ]]; then
    echo "Unsupported distribution: ${PRETTY_NAME}. This feature requires Debian or Ubuntu." >&2
    exit 1
fi

export DEBIAN_FRONTEND=noninteractive
echo "Step 3, install prerequisites"
rm -rf /var/lib/apt/lists/*
apt-get update -y
apt-get install -y --no-install-recommends ca-certificates curl unzip

# renovate: datasource=github-releases depName=ktlint/ktlint
KTLINT_VERSION=1.8.0
# renovate: datasource=github-releases depName=JetBrains/kotlin
KOTLIN_VERSION=v2.4.20

install_dir="$(mktemp -d)"
trap 'rm -rf "$install_dir"' EXIT

echo "Step 4, install ktlint ${KTLINT_VERSION}"
curl -fsSL "https://github.com/ktlint/ktlint/releases/download/${KTLINT_VERSION}/ktlint" -o "${install_dir}/ktlint"
install -m 755 "${install_dir}/ktlint" /usr/local/bin/ktlint

echo "Step 5, install Kotlin ${KOTLIN_VERSION}"
kotlin_number="${KOTLIN_VERSION#v}"
curl -fsSL "https://github.com/JetBrains/kotlin/releases/download/${KOTLIN_VERSION}/kotlin-compiler-${kotlin_number}.zip" -o "${install_dir}/kotlinc.zip"
unzip -oq "${install_dir}/kotlinc.zip" -d /opt/

echo "Step 6, clean up"
rm -rf /var/lib/apt/lists/*
echo "Done!"
