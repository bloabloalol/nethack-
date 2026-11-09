#!/bin/sh

HACKDIR=/usr/games/lib/nethackdir
GAME_BINARY="$HACKDIR/nethack"
SCREEN_CONFIG="$HACKDIR/.screenrc"

clear
printf '%s\n' "========================================="
printf '%s\n' "        NetHack 5.0.0 Launcher           "
printf '%s\n' "========================================="
printf '%s\n' "Choose your gameplay mode:"
printf '%s\n' "1) Normal Mode (Standard play)"
printf '%s\n' "2) Wizard Mode (Debug / Exploration)"
printf '%s\n' "========================================="
printf '%s' "Enter choice [1 or 2]: "
read choice

case "$choice" in
    2)
        printf '%s\n' "Launching in Wizard Mode..."
        exec "$GAME_BINARY" -D -u wizard
        ;;
    *)
        printf '%s\n' "Launching in Normal Mode..."
        exec "$GAME_BINARY"
        ;;
esac
