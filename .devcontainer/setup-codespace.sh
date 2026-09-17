#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
PLAYGROUND_DIR="${REPO_ROOT}/NetHack/playground"
TARGET_DIR="${HOME}/.local/bin"
TARGET="${TARGET_DIR}/nethack"
DEBUGGER_TARGET="${TARGET_DIR}/debugger"

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

if ! command -v gdb >/dev/null 2>&1; then
    echo "Installing gdb dependency..."
    if command -v sudo >/dev/null 2>&1; then
        sudo apt-get update -qq
        sudo apt-get install -y gdb
    else
        apt-get update -qq
        apt-get install -y gdb
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

cat > "${DEBUGGER_TARGET}" <<EOF
#!/usr/bin/env bash
set -euo pipefail
exec gdb "${PLAYGROUND_DIR}/nethack" -p "\$(pgrep -n nethack)"
EOF
chmod +x "${DEBUGGER_TARGET}"

printf '\nNetHack launcher installed in %s. Type: nethack\n' "${TARGET}"
printf 'Debugger command installed in %s. Type: debugger while NetHack is running.\n' "${DEBUGGER_TARGET}"
