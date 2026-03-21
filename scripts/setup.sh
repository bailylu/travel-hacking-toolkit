#!/usr/bin/env bash
set -euo pipefail

# Travel Hacking Toolkit - Setup Script
# Installs skills and MCP configs for OpenCode or Claude Code.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=== Travel Hacking Toolkit Setup ==="
echo ""

# --- Detect tool ---
echo "Which AI coding tool do you use?"
echo "  1) OpenCode"
echo "  2) Claude Code"
echo "  3) Both"
echo "  4) Just project-level (I'll work from this directory)"
echo ""
read -rp "Choice [1-4]: " TOOL_CHOICE

install_opencode_skills() {
  local target="$HOME/.config/opencode/skills"
  echo ""
  echo "Installing skills to $target..."
  mkdir -p "$target"

  for skill_dir in "$REPO_DIR"/skills/*/; do
    skill_name=$(basename "$skill_dir")
    dest="$target/$skill_name"

    if [ -d "$dest" ]; then
      echo "  Updating $skill_name..."
      rm -rf "$dest"
    else
      echo "  Installing $skill_name..."
    fi

    cp -r "$skill_dir" "$dest"
  done

  echo "  Done. Skills installed to $target"
}

install_claude_skills() {
  local target="$HOME/.claude/skills"
  echo ""
  echo "Installing skills to $target..."
  mkdir -p "$target"

  for skill_dir in "$REPO_DIR"/skills/*/; do
    skill_name=$(basename "$skill_dir")
    dest="$target/$skill_name"

    if [ -d "$dest" ]; then
      echo "  Updating $skill_name..."
      rm -rf "$dest"
    else
      echo "  Installing $skill_name..."
    fi

    cp -r "$skill_dir" "$dest"
  done

  echo "  Done. Skills installed to $target"
}

setup_project_level() {
  echo ""
  echo "Setting up project-level symlinks..."

  # OpenCode
  mkdir -p "$REPO_DIR/.opencode"
  if [ ! -e "$REPO_DIR/.opencode/skills" ]; then
    ln -s ../skills "$REPO_DIR/.opencode/skills"
    echo "  Created .opencode/skills -> skills/"
  else
    echo "  .opencode/skills already exists, skipping"
  fi

  # Claude Code
  mkdir -p "$REPO_DIR/.claude"
  if [ ! -e "$REPO_DIR/.claude/skills" ]; then
    ln -s ../skills "$REPO_DIR/.claude/skills"
    echo "  Created .claude/skills -> skills/"
  else
    echo "  .claude/skills already exists, skipping"
  fi
}

setup_env() {
  echo ""

  # OpenCode: .env
  if [ ! -f "$REPO_DIR/.env" ]; then
    cp "$REPO_DIR/.env.example" "$REPO_DIR/.env"
    echo "  Created .env for OpenCode. Edit it to add your API keys."
  else
    echo "  .env already exists. Skipping."
  fi

  # Claude Code: settings.local.json
  local claude_settings="$REPO_DIR/.claude/settings.local.json"
  if [ ! -f "$claude_settings" ]; then
    if [ -f "$REPO_DIR/.claude/settings.local.json.example" ]; then
      cp "$REPO_DIR/.claude/settings.local.json.example" "$claude_settings"
      echo "  Created .claude/settings.local.json for Claude Code (auto-gitignored)."
      echo "  Edit it to add your API keys."
    fi
  else
    echo "  .claude/settings.local.json already exists. Skipping."
  fi

  echo ""
  echo "  Minimum recommended keys to get started:"
  echo "    SEATS_AERO_API_KEY    - Award flight search (the main event)"
  echo "    SERPAPI_API_KEY        - Cash price comparison"
  echo ""
}

install_atlas_deps() {
  echo ""
  echo "Installing Atlas Obscura dependencies..."
  if command -v npm &>/dev/null; then
    (cd "$REPO_DIR/skills/atlas-obscura" && npm install --silent 2>/dev/null)
    echo "  Done."
  else
    echo "  npm not found. Install Node.js to use the Atlas Obscura skill."
  fi
}

# --- Execute ---
case "$TOOL_CHOICE" in
  1)
    install_opencode_skills
    ;;
  2)
    install_claude_skills
    ;;
  3)
    install_opencode_skills
    install_claude_skills
    ;;
  4)
    setup_project_level
    ;;
  *)
    echo "Invalid choice. Exiting."
    exit 1
    ;;
esac

setup_env
install_atlas_deps

echo ""
echo "=== Setup complete! ==="
echo ""
echo "Next steps:"
echo "  1. Add your API keys:"
echo "     OpenCode:    edit .env"
echo "     Claude Code: edit .claude/settings.local.json"
echo "  2. Launch your AI tool:"
echo "     OpenCode:    opencode"
echo "     Claude Code: claude --strict-mcp-config --mcp-config .mcp.json"
echo "  3. Ask it to find you a cheap business class flight to Tokyo"
echo ""
