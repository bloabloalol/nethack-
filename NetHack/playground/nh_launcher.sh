#!/bin/bash

# Configuration paths
SCREEN_CONFIG="/workspaces/nethack-/NetHack/playground/.screenrc"
GAME_BINARY="/workspaces/nethack-/NetHack/playground/nethack"

clear
echo "========================================="
echo "        NetHack 5.0.0 Launcher           "
echo "========================================="
echo "Choose your gameplay mode:"
echo "1) Normal Mode (Standard play)"
echo "2) Wizard Mode (Debug / Exploration)"
echo "========================================="
read -p "Enter choice [1 or 2]: " choice

case $choice in
    2)
        echo "Launching in Wizard Mode..."
        screen -c "$SCREEN_CONFIG" "$GAME_BINARY" -D -u wizard
        ;;
    *)
        echo "Launching in Normal Mode..."
        screen -c "$SCREEN_CONFIG" "$GAME_BINARY"
        ;;
esac
