#!/bin/sh

set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SETTINGS_FILE=${NETHACK_VARIANTS_SETTINGS:-"$ROOT_DIR/settings.conf"}

if [ -f "$SETTINGS_FILE" ]; then
    . "$SETTINGS_FILE"
fi

VARIANT=${VARIANT:-nethack}
MODE=${MODE:-normal}
GDB=${GDB:-gdb}

usage() {
    printf '%s\n' "Usage: $0 [nethack|hackem|slashem] [--normal|--wizard|--debug]"
}

save_settings() {
    umask 077
    printf 'VARIANT=%s\nMODE=%s\nGDB=%s\n' "$VARIANT" "$MODE" "$GDB" > "$SETTINGS_FILE"
}

case "${1:-}" in
    '') ;;
    nethack|hackem|slashem) VARIANT=$1; shift ;;
esac

case "${1:-}" in
    '') ;;
    --debug) MODE=debug; shift ;;
    --wizard) MODE=wizard; shift ;;
    --normal) MODE=normal; shift ;;
    --help|-h) usage; exit 0 ;;
    *) usage >&2; exit 2 ;;
esac

[ "$#" -eq 0 ] || { usage >&2; exit 2; }

case "$VARIANT" in
    nethack)
        GAME="$ROOT_DIR/NetHack/playground/nethack"
        ;;
    hackem)
        GAME="$ROOT_DIR/HackEM/playground/hackem"
        ;;
    slashem)
        GAME="$ROOT_DIR/SLASHEM/playground/slex"
        ;;
esac

if [ ! -x "$GAME" ]; then
    printf '%s\n' "${VARIANT} is not built: $GAME" >&2
    printf '%s\n' "Build it in the ${VARIANT} source tree before launching." >&2
    exit 1
fi

save_settings

if [ "$MODE" = debug ]; then
    command -v "$GDB" >/dev/null 2>&1 || {
        printf '%s\n' "Debugger not found: $GDB" >&2
        exit 1
    }
    exec "$GDB" --args "$GAME" -D -u wizard
fi

if [ "$MODE" = wizard ]; then
    exec "$GAME" -D -u wizard
fi

exec "$GAME"