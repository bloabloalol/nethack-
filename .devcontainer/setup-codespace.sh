#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
PLAYGROUND_DIR="${REPO_ROOT}/NetHack/playground"
TARGET_DIR="${HOME}/.local/bin"
TARGET="${TARGET_DIR}/nethack"

if ! command -v screen >/dev/null 2>&1; then
    echo "Installing screen dependency..."
    if command -v sudo >/dev/null 2>&1; then
        sudo apt-get update -qq
        sudo apt-get install -y screen
    else
        apt-get update -qq
        apt-get install -y screen
    fi
fi

mkdir -p "${TARGET_DIR}"

if [[ ! -x "${PLAYGROUND_DIR}/nethack" ]]; then
    echo "Building NetHack in ${PLAYGROUND_DIR}..."
    cd "${PLAYGROUND_DIR}"
    make
fi

cat > "${TARGET}" <<EOF
#!/usr/bin/env bash
set -euo pipefail
exec "${PLAYGROUND_DIR}/nh_launcher.sh" "\$@"
EOF
chmod +x "${TARGET}"

printf '\nNetHack launcher installed in %s. Type: nethack\n' "${TARGET}"
