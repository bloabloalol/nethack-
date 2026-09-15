#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SCREEN_CONFIG="${SCRIPT_DIR}/.screenrc"
GAME_BINARY="${SCRIPT_DIR}/nethack"

if [[ ! -x "${GAME_BINARY}" ]]; then
    echo "Error: NetHack binary not found at ${GAME_BINARY}" >&2
    echo "Build it first from the playground directory with: make" >&2
    exit 1
fi

if ! command -v screen >/dev/null 2>&1; then
    echo "Error: 'screen' is required but is not installed." >&2
    exit 1
fi

clear
echo "========================================="
echo "        NetHack 5.0.0 Launcher           "
echo "========================================="
echo "Choose your gameplay mode:"
echo "1) Normal Mode (Standard play)"
echo "2) Wizard Mode (Debug / Exploration)"
echo "========================================="

choice="${1:-}"
if [[ -z "${choice}" ]]; then
    read -r -p "Enter choice [1 or 2]: " choice || choice="1"
fi

case "${choice}" in
    2|wizard|--wizard)
        echo "Launching in Wizard Mode..."
        exec screen -c "${SCREEN_CONFIG}" "${GAME_BINARY}" -D -u wizard
        ;;
    1|normal|--normal|"")
        echo "Launching in Normal Mode..."
        exec screen -c "${SCREEN_CONFIG}" "${GAME_BINARY}"
        ;;
    *)
        echo "Invalid choice: ${choice}. Defaulting to Normal Mode..."
        exec screen -c "${SCREEN_CONFIG}" "${GAME_BINARY}"
        ;;
esac
