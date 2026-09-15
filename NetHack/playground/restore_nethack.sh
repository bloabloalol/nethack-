
# Automatically re-verify and install GDB package if missing after an OS rebuild
if ! command -v gdb &> /dev/null; then
    sudo apt update && sudo apt install -y gdb
fi
ln -sf /workspaces/nethack-/NetHack/playground/.nethackrc ~/.nethackrc
ln -sf /workspaces/nethack-/NetHack/playground/.nethackrc ~/.nethackrc
alias debugger='gdb /workspaces/nethack-/NetHack/playground/nethack -p $(pgrep -n nethack)'
