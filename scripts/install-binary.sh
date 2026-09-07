#!/bin/bash
# Download omail binary to CLAUDE_PLUGIN_DATA on first run or version change
set -e

DATA_DIR="${CLAUDE_PLUGIN_DATA:-$HOME/.officemail}"
PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-.}"
VERSION_FILE="$DATA_DIR/.version"
CURRENT_VERSION=$(grep '"version"' "$PLUGIN_ROOT/.claude-plugin/plugin.json" | head -1 | sed 's/.*: *"\(.*\)".*/\1/')
BINARY="$DATA_DIR/omail"
REPO="jiransoft/om-official"

# Detect platform and architecture
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
case "$ARCH" in
  x86_64)  ARCH="x64" ;;
  aarch64|arm64) ARCH="arm64" ;;
esac

case "$OS" in
  darwin|linux) TARGET="omail-${OS}-${ARCH}" ;;
  mingw*|msys*|cygwin*) TARGET="omail-windows-${ARCH}.exe" ;;
  *) echo "Unsupported OS: $OS" >&2; exit 0 ;;
esac

# Skip if already installed and version matches
if [ -f "$BINARY" ] && [ -f "$VERSION_FILE" ] && [ "$(cat "$VERSION_FILE")" = "$CURRENT_VERSION" ]; then
  exit 0
fi

mkdir -p "$DATA_DIR"

echo "Installing omail $CURRENT_VERSION ($TARGET)..." >&2
URL="https://github.com/$REPO/releases/download/${CURRENT_VERSION}/${TARGET}"
if curl -fsSL -o "$BINARY" "$URL"; then
  chmod +x "$BINARY"
  echo "$CURRENT_VERSION" > "$VERSION_FILE"
  echo "omail $CURRENT_VERSION installed to $BINARY" >&2
else
  echo "Failed to download omail from $URL" >&2
  echo "Download manually from https://github.com/$REPO/releases" >&2
  exit 0
fi
