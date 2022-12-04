#!/bin/bash

set -e

# Clean up
rm -rf /var/lib/apt/lists/*

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root to be able to installe dependencies, changing to sudo when installing.'
fi

apt_get_update() {
    if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        if [ "$(id -u)" -ne 0 ]; then
            sudo apt-get update -y
        else
            apt-get update -y
        fi
    fi
}

check_packages() {
    if ! dpkg -s "$@" >/dev/null 2>&1; then
        apt_get_update
        if [ "$(id -u)" -ne 0 ]; then
            sudo apt-get -y install --no-install-recommends "$@"
        else
            apt-get -y install --no-install-recommends "$@"
        fi
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
check "version" kotlinc -version

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
