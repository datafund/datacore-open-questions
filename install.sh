#!/bin/bash
#
# Open Questions module installer
# Registers slash commands with Claude Code
#

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_COMMANDS="$HOME/.claude/commands"

echo "Installing Open Questions module..."

# Create commands directory if needed
mkdir -p "$CLAUDE_COMMANDS"

# Symlink commands
for cmd in "$SCRIPT_DIR/commands/"*.md; do
    name=$(basename "$cmd")
    if [ -L "$CLAUDE_COMMANDS/$name" ]; then
        rm "$CLAUDE_COMMANDS/$name"
    fi
    ln -s "$cmd" "$CLAUDE_COMMANDS/$name"
    echo "  Registered /$name"
done

echo ""
echo "Done! Commands available:"
echo "  /my-questions"
echo "  /add-question"
echo "  /meeting-agenda"
echo "  /close-questions"
echo ""
echo "Restart Claude Code or start new conversation to use them."
