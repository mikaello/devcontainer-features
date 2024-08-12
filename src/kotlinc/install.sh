#!/usr/bin/env bash
set -e

echo "Activating feature 'kotlinc'"
# Clean up
rm -rf /var/lib/apt/lists/*

echo "Step 1, check if user is root"
if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

echo "Step 2, determine appropriate non-root user"
if [ "${USERNAME}" = "auto" ] || [ "${USERNAME}" = "automatic" ]; then
    USERNAME=""
    POSSIBLE_USERS=("vscode" "node" "codespace" "$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)")
    for CURRENT_USER in "${POSSIBLE_USERS[@]}"; do
        if id -u "${CURRENT_USER}" >/dev/null 2>&1; then
            USERNAME=${CURRENT_USER}
            break
        fi
    done
    if [ "${USERNAME}" = "" ]; then
        USERNAME=root
    fi
elif [ "${USERNAME}" = "none" ] || ! id -u ${USERNAME} >/dev/null 2>&1; then
    USERNAME=root
fi

echo "Step 3, define helper functions"
updaterc() {
    if [ "${UPDATE_RC}" = "true" ]; then
        echo "Updating /etc/bash.bashrc and /etc/zsh/zshrc..."
        if [[ "$(cat /etc/bash.bashrc)" != *"$1"* ]]; then
            echo -e "$1" >> /etc/bash.bashrc
        fi
        if [ -f "/etc/zsh/zshrc" ] && [[ "$(cat /etc/zsh/zshrc)" != *"$1"* ]]; then
            echo -e "$1" >> /etc/zsh/zshrc
        fi
    fi
}

apt_get_update()
{
    if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        apt-get update -y
    fi
}

# Checks if packages are installed and installs them if not
check_packages() {
    if ! dpkg -s "$@" > /dev/null 2>&1; then
        apt_get_update
        apt-get -y install --no-install-recommends "$@"
    fi
}

export DEBIAN_FRONTEND=noninteractive


echo "Step 4, check if architecture is supported"
architecture="$(uname -m)"
if [ "${architecture}" != "amd64" ] && [ "${architecture}" != "x86_64" ] && [ "${architecture}" != "arm64" ] && [ "${architecture}" != "aarch64" ]; then
    echo "(!) Architecture $architecture unsupported"
    exit 1
fi


echo "Step 5, install packages"

# Install dependencies
check_packages ca-certificates curl unzip

# renovate: datasource=github-releases depName=pinterest/ktlint
KTLINT_VERSION=1.3.1
curl -sSfLO https://github.com/pinterest/ktlint/releases/download/${KTLINT_VERSION}/ktlint \
  && chmod a+x ktlint \
  && mv ktlint /usr/local/bin

# renovate: datasource=github-releases depName=JetBrains/kotlin
KOTLIN_VERSION=v2.0.10
export KT_VERSION=$(echo $KOTLIN_VERSION | cut -c2-) \
 && curl -sSfLo kotlinc.zip https://github.com/JetBrains/kotlin/releases/download/${KOTLIN_VERSION}/kotlin-compiler-${KT_VERSION}.zip \
 && unzip kotlinc.zip -d /opt/ \
 && rm kotlinc.zip

UPDATE_RC=true
updaterc "export KOTLINC_BIN_DIR=\"/opt/kotlinc/bin\""
updaterc "if [[ \"\${PATH}\" != *\"\${KOTLINC_BIN_DIR}\"* ]]; then export PATH=\"\${PATH}:\${KOTLINC_BIN_DIR}\"; fi"
UPDATE_RC=false

# Clean up
rm -rf /var/lib/apt/lists/*

echo "Done!"
