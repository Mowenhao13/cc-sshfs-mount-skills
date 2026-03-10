#!/bin/bash
# SSHFS Mount Manager - Installation Script
# This script installs the SSHFS Mount Manager skill for Claude Code

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$HOME/.claude/skills/sshfs-mount"
CONFIG_DIR="$HOME/.config/sshfs-mounts"

echo "=============================================="
echo "SSHFS Mount Manager - Installation"
echo "=============================================="
echo ""

# Check for sshfs
if ! command -v sshfs &> /dev/null; then
    echo "Warning: sshfs is not installed."
    echo "Please install sshfs first:"
    echo "  macOS: brew install sshfs"
    echo "  Ubuntu: sudo apt-get install sshfs"
    echo ""
    read -p "Continue anyway? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Create directories
echo "Creating directories..."
mkdir -p "$INSTALL_DIR"
mkdir -p "$CONFIG_DIR"
mkdir -p "$CONFIG_DIR/profiles"

# Copy files
echo "Copying files..."
cp "$SCRIPT_DIR/sshfs_mount.py" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/sshfs_daemon.py" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/generate_claude_md.py" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/skill/sshfs" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/skill/sshfs-mount.sh" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/skill/sshfs-mount.md" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/skill/SKILL.md" "$INSTALL_DIR/"

# Make scripts executable
chmod +x "$INSTALL_DIR/sshfs_mount.py"
chmod +x "$INSTALL_DIR/sshfs_daemon.py"
chmod +x "$INSTALL_DIR/generate_claude_md.py"
chmod +x "$INSTALL_DIR/sshfs"
chmod +x "$INSTALL_DIR/sshfs-mount.sh"

# Create wrapper script for easy access
WRAPPER_SCRIPT="$HOME/.local/bin/sshfs-mount"
mkdir -p "$(dirname "$WRAPPER_SCRIPT")"

cat > "$WRAPPER_SCRIPT" << 'EOF'
#!/bin/bash
exec python3 ~/.claude/skills/sshfs-mount/sshfs_mount.py "$@"
EOF

chmod +x "$WRAPPER_SCRIPT"

# Create daemon wrapper
DAEMON_WRAPPER="$HOME/.local/bin/sshfs-daemon"
cat > "$DAEMON_WRAPPER" << 'EOF'
#!/bin/bash
exec python3 ~/.claude/skills/sshfs-mount/sshfs_daemon.py "$@"
EOF

chmod +x "$DAEMON_WRAPPER"

echo ""
echo "=============================================="
echo "Installation Complete!"
echo "=============================================="
echo ""
echo "The SSHFS Mount Manager has been installed to:"
echo "  $INSTALL_DIR"
echo ""
echo "Command-line wrappers installed to:"
echo "  $WRAPPER_SCRIPT"
echo "  $DAEMON_WRAPPER"
echo ""
echo "To use with Claude Code:"
echo "  1. Restart Claude Code"
echo "  2. Run /sshfs-mount to see available commands"
echo ""
echo "To use from command line:"
echo "  sshfs-mount status"
echo "  sshfs-mount mount"
echo "  sshfs-mount unmount"
echo "  sshfs-mount init  (first-time setup)"
echo ""
echo "=============================================="
echo ""

# Check if ~/.local/bin is in PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo "Note: $HOME/.local/bin is not in your PATH."

    # Offer to add it to shell config
    read -p "Add to ~/.zshrc automatically? [Y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        echo '' >> ~/.zshrc
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
        echo "✓ Added to ~/.zshrc"
        echo "  Run 'source ~/.zshrc' or restart terminal to apply."
    else
        echo "Add this to your ~/.zshrc or ~/.bashrc manually:"
        echo "  export PATH=\"$HOME/.local/bin:\$PATH\""
    fi
    echo ""
fi

# First-time setup prompt
if [[ ! -f "$CONFIG_DIR/config.yaml" ]] && [[ ! -f "$CONFIG_DIR/profiles/default.yaml" ]]; then
    echo "No configuration found. Run initialization?"
    read -p "Run setup wizard now? [Y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        python3 "$INSTALL_DIR/sshfs_mount.py" init
    fi
fi
