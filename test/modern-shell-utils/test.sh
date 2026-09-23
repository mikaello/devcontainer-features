#!/bin/bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.
check "eza" eza --version
check "fd" fd --version
check "ripgrep" rg --version
check "ag compatibility command" ag --version
check "ag simple search" bash -c 'printf "feature-check\n" | ag feature-check'
check "bat" bat --version

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
