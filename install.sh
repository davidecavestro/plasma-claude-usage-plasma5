#!/bin/bash

PLUGIN_ID="org.kde.plasma.claudeusage.plasma5"
INSTALL_DIR="$HOME/.local/share/plasma/plasmoids/$PLUGIN_ID"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing Claude Usage widget..."

mkdir -p "$INSTALL_DIR"
cp -r "$SCRIPT_DIR/contents" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/metadata.desktop" "$INSTALL_DIR/"

echo "Installed to $INSTALL_DIR"
echo ""
echo "Restart Plasma to apply changes:"
echo "  kquitapp5 plasmashell && kstart5 plasmashell"
