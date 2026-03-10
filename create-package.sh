#!/bin/bash
# SSHFS Mount Manager - Create Distribution Package
# This script creates a tarball for easy distribution

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_NAME="sshfs-mount"
VERSION="1.0.0"

echo "Creating distribution package..."

# Create temp directory for packaging
TEMP_DIR=$(mktemp -d)
PACKAGE_DIR="$TEMP_DIR/$PACKAGE_NAME"

# Create package structure
mkdir -p "$PACKAGE_DIR"
mkdir -p "$PACKAGE_DIR/skill"

# Copy files
cp "$SCRIPT_DIR/sshfs_mount.py" "$PACKAGE_DIR/"
cp "$SCRIPT_DIR/sshfs_daemon.py" "$PACKAGE_DIR/"
cp "$SCRIPT_DIR/generate_claude_md.py" "$PACKAGE_DIR/"
cp "$SCRIPT_DIR/install.sh" "$PACKAGE_DIR/"
cp "$SCRIPT_DIR/README.md" "$PACKAGE_DIR/"
cp "$SCRIPT_DIR/USAGE.md" "$PACKAGE_DIR/"
cp "$SCRIPT_DIR/skill/sshfs" "$PACKAGE_DIR/skill/"
cp "$SCRIPT_DIR/skill/sshfs-mount.sh" "$PACKAGE_DIR/skill/"
cp "$SCRIPT_DIR/skill/sshfs-mount.md" "$PACKAGE_DIR/skill/"

# Make scripts executable
chmod +x "$PACKAGE_DIR"/*.sh
chmod +x "$PACKAGE_DIR"/*.py
chmod +x "$PACKAGE_DIR/skill"/*.sh
chmod +x "$PACKAGE_DIR/skill/sshfs"

# Create tarball
cd "$TEMP_DIR"
tar -czf "$SCRIPT_DIR/${PACKAGE_NAME}-${VERSION}.tar.gz" "$PACKAGE_NAME"

# Cleanup
rm -rf "$TEMP_DIR"

echo ""
echo "=============================================="
echo "Distribution package created:"
echo "  $SCRIPT_DIR/${PACKAGE_NAME}-${VERSION}.tar.gz"
echo "=============================================="
echo ""
echo "To install on another machine:"
echo "  1. Copy the tarball to the target machine"
echo "  2. Extract: tar -xzf ${PACKAGE_NAME}-${VERSION}.tar.gz"
echo "  3. Install: cd ${PACKAGE_NAME} && ./install.sh"
echo ""
