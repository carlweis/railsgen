#!/usr/bin/env bash

# =============================================================================
# railsgen Installation Script
# =============================================================================

set -e

INSTALL_DIR="${HOME}/.railsgen"
REPO_URL="https://github.com/carlweis/railsgen"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

print_color() {
    local color=$1
    shift
    echo -e "${color}$@${NC}"
}

print_color $CYAN "╔══════════════════════════════════════════════════════════════════╗"
print_color $CYAN "║                    railsgen Installation                         ║"
print_color $CYAN "╚══════════════════════════════════════════════════════════════════╝"
echo ""

# Create installation directory
print_color $YELLOW "Creating installation directory at $INSTALL_DIR..."
mkdir -p "$INSTALL_DIR/bin"

# Copy files (when running from the repo)
if [ -f "template.rb" ]; then
    print_color $YELLOW "Installing from local files..."
    cp template.rb "$INSTALL_DIR/"
    cp bin/railsgen "$INSTALL_DIR/bin/"
    cp README.md "$INSTALL_DIR/" 2>/dev/null || true
else
    print_color $RED "Error: Run this script from the railsgen directory"
    exit 1
fi

# Make executable
chmod +x "$INSTALL_DIR/bin/railsgen"

# Determine shell config file
SHELL_CONFIG=""
if [ -f "$HOME/.zshrc" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_CONFIG="$HOME/.bashrc"
elif [ -f "$HOME/.bash_profile" ]; then
    SHELL_CONFIG="$HOME/.bash_profile"
fi

# Check if already in PATH
if echo "$PATH" | grep -q "$INSTALL_DIR/bin"; then
    print_color $GREEN "✓ railsgen is already in your PATH"
else
    if [ -n "$SHELL_CONFIG" ]; then
        echo "" >> "$SHELL_CONFIG"
        echo "# railsgen" >> "$SHELL_CONFIG"
        echo "export PATH=\"\$PATH:$INSTALL_DIR/bin\"" >> "$SHELL_CONFIG"
        print_color $GREEN "✓ Added railsgen to PATH in $SHELL_CONFIG"
    else
        print_color $YELLOW "Could not detect shell configuration file."
        print_color $YELLOW "Please add the following to your shell config:"
        echo ""
        echo "  export PATH=\"\$PATH:$INSTALL_DIR/bin\""
        echo ""
    fi
fi

echo ""
print_color $GREEN "═══════════════════════════════════════════════════════════════════"
print_color $GREEN "✨ Installation complete!"
print_color $GREEN "═══════════════════════════════════════════════════════════════════"
echo ""
print_color $YELLOW "To use railsgen, either:"
echo "  1. Open a new terminal"
echo "  2. Or run: source $SHELL_CONFIG"
echo ""
print_color $CYAN "Then create your first app:"
echo "  railsgen myapp"
echo ""
