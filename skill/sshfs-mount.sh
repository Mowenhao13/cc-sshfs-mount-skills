#!/bin/bash
# SSHFS Mount Manager - Claude Code Skill
# This script is called by Claude Code when the user invokes /sshfs-mount

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PYTHON_SCRIPT="$SCRIPT_DIR/sshfs_mount.py"
DAEMON_SCRIPT="$SCRIPT_DIR/sshfs_daemon.py"
GENERATE_CLAUDE_MD="$SCRIPT_DIR/generate_claude_md.py"

# Ensure the Python script exists
if [[ ! -f "$PYTHON_SCRIPT" ]]; then
    echo "Error: sshfs_mount.py not found at $PYTHON_SCRIPT"
    echo "Please run the initialization first."
    exit 1
fi

# Get the subcommand
SUBCOMMAND="${1:-help}"
shift 2>/dev/null || true

case "$SUBCOMMAND" in
    status)
        python3 "$PYTHON_SCRIPT" status
        ;;
    mount)
        python3 "$PYTHON_SCRIPT" mount -v
        ;;
    unmount)
        python3 "$PYTHON_SCRIPT" unmount -v
        ;;
    init)
        python3 "$PYTHON_SCRIPT" init
        ;;
    profile)
        python3 "$PYTHON_SCRIPT" profile "$@"
        ;;
    daemon)
        python3 "$DAEMON_SCRIPT" "$@"
        ;;
    generate-claude-md)
        python3 "$GENERATE_CLAUDE_MD" generate-all
        ;;
    config-path)
        python3 "$PYTHON_SCRIPT" config-path
        ;;
    help|*)
        echo "SSHFS Mount Manager"
        echo ""
        echo "Usage: /sshfs-mount <command>"
        echo ""
        echo "Commands:"
        echo "  (none)           Show this help"
        echo "  status           Show mount status for all remotes"
        echo "  mount            Mount all remote directories"
        echo "  unmount          Unmount all remote directories"
        echo "  init             Run initialization wizard"
        echo "  profile          Profile management (list, switch)"
        echo "  daemon           Daemon management (start, stop, status)"
        echo "  generate-claude-md  Generate CLAUDE.md for mounted remotes"
        echo "  config-path      Show configuration file path"
        echo ""
        echo "Examples:"
        echo "  /sshfs-mount mount"
        echo "  /sshfs-mount status"
        echo "  /sshfs-mount daemon start"
        echo "  /sshfs-mount generate-claude-md"
        ;;
esac
