#!/bin/bash

set -e

# Clean up
rm -rf /var/lib/apt/lists/*

apt_get_update() {
    if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        apt-get update -y
    fi
}

check_packages() {
    if ! dpkg -s "$@" >/dev/null 2>&1; then
        apt_get_update
        apt-get -y install --no-install-recommends "$@"
    fi
}
export DEBIAN_FRONTEND=noninteractive

check_packages default-jre

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

echo $PATH

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.
check "version" ktlint --version
check "version" /opt/kotlinc/bin/kotlinc -version

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults