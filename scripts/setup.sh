#!/usr/bin/env bash
set -euo pipefail

# Travel Hacking Toolkit - Setup Script
# Gets you from clone to working in under a minute.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=== Travel Hacking Toolkit Setup ==="
echo ""

# --- Which tool? ---
echo "Which AI coding tool do you use?"
echo "  1) OpenCode"
echo "  2) Claude Code"
echo "  3) Both"
echo ""
read -rp "Choice [1-3]: " TOOL_CHOICE

case "$TOOL_CHOICE" in
  1|2|3) ;;
  *)
    echo "Invalid choice. Exiting."
    exit 1
    ;;
esac

# --- API key setup ---
setup_api_keys() {
  echo ""
  echo "Setting up API keys..."

  if [[ "$TOOL_CHOICE" == "1" || "$TOOL_CHOICE" == "3" ]]; then
    if [ ! -f "$REPO_DIR/.env" ]; then
      cp "$REPO_DIR/.env.example" "$REPO_DIR/.env"
      echo "  Created .env. Edit it to add your API keys."
    else
      echo "  .env already exists. Skipping."
    fi
  fi

  if [[ "$TOOL_CHOICE" == "2" || "$TOOL_CHOICE" == "3" ]]; then
    local claude_settings="$REPO_DIR/.claude/settings.local.json"
    if [ ! -f "$claude_settings" ]; then
      if [ -f "$REPO_DIR/.claude/settings.local.json.example" ]; then
        cp "$REPO_DIR/.claude/settings.local.json.example" "$claude_settings"
        echo "  Created .claude/settings.local.json."
        echo "  Edit it to add your API keys."
      fi
    else
      echo "  .claude/settings.local.json already exists. Skipping."
    fi
  fi

  echo ""
  echo "  REQUIRED API Keys:"
  echo "    SERPAPI_API_KEY  - Get at https://serpapi.com (100 free searches/month)"
  echo "    FLYAI_API_KEY    - Get at https://open.fliggy.com/ (飞猪开放平台)"
  echo ""
  echo "  FREE (no key needed):"
  echo "    fli              - International flights via Google Flights"
  echo "    premium-hotels   - FHR/Chase Edit hotel lookup (local data)"
  echo ""
}

# --- Install Fli ---
install_fli() {
  echo ""
  echo "Installing Fli (Google Flights CLI)..."
  if command -v fli &>/dev/null; then
    echo "  ✓ fli already installed"
  else
    echo "  Installing fli..."
    # Check if pipx is available
    if command -v pipx &>/dev/null; then
      pipx install flights 2>/dev/null || echo "  pipx install failed, trying pip..."
    fi
    # Fallback to pip
    if ! command -v fli &>/dev/null; then
      pip install flights 2>/dev/null || echo "  pip install failed"
    fi
    if command -v fli &>/dev/null; then
      echo "  ✓ fli installed"
    else
      echo "  ⚠ fli not in PATH. You may need to manually install."
      echo "    pipx install flights"
    fi
  fi
}

# --- Install FlyAI ---
install_flyai() {
  echo ""
  echo "Installing FlyAI (Fliggy CLI for China travel)..."
  if command -v flyai &>/dev/null; then
    echo "  ✓ flyai already installed"
  else
    echo "  Installing flyai..."
    if command -v npm &>/dev/null; then
      npm install -g @lobehub/flyai-cli 2>/dev/null || echo "  npm install failed"
    fi
    if ! command -v flyai &>/dev/null; then
      echo "  ⚠ flyai not installed. Install with:"
      echo "    npm install -g @lobehub/flyai-cli"
      echo "    FlyAI requires Node.js 20+"
    else
      echo "  ✓ flyai installed"
    fi
  fi
}

# --- Global install (optional) ---
offer_global_install() {
  echo ""
  echo "Skills are already available when you work from this directory."
  echo "Want to also install them system-wide (available in any project)?"
  echo ""
  read -rp "Install globally? [y/N]: " GLOBAL_CHOICE

  if [[ "$GLOBAL_CHOICE" == "y" || "$GLOBAL_CHOICE" == "Y" ]]; then
    if [[ "$TOOL_CHOICE" == "1" || "$TOOL_CHOICE" == "3" ]]; then
      install_skills_to "$HOME/.config/opencode/skills"
    fi
    if [[ "$TOOL_CHOICE" == "2" || "$TOOL_CHOICE" == "3" ]]; then
      install_skills_to "$HOME/.claude/skills"
    fi
  else
    echo "  Skipped. You can always run this script again later."
  fi
}

install_skills_to() {
  local target="$1"
  echo ""
  echo "  Installing skills to $target..."
  mkdir -p "$target"

  for skill_dir in "$REPO_DIR"/skills/*/; do
    skill_name=$(basename "$skill_dir")
    dest="$target/$skill_name"

    if [ -d "$dest" ]; then
      echo "    Updating $skill_name..."
      rm -rf "$dest"
    else
      echo "    Installing $skill_name..."
    fi

    cp -r "$skill_dir" "$dest"
  done

  echo "  Done."
}

# --- Run ---
setup_api_keys
install_fli
install_flyai
offer_global_install

echo ""
echo "=== Setup complete! ==="
echo ""
echo "Launch your tool from this directory:"

if [[ "$TOOL_CHOICE" == "1" || "$TOOL_CHOICE" == "3" ]]; then
  echo "  OpenCode:    opencode"
fi
if [[ "$TOOL_CHOICE" == "2" || "$TOOL_CHOICE" == "3" ]]; then
  echo "  Claude Code: claude --strict-mcp-config --mcp-config .mcp.json"
fi

echo ""

if [[ "$TOOL_CHOICE" == "1" || "$TOOL_CHOICE" == "3" ]]; then
  echo "Add your API keys:  edit .env"
fi
if [[ "$TOOL_CHOICE" == "2" || "$TOOL_CHOICE" == "3" ]]; then
  echo "Add your API keys:  edit .claude/settings.local.json"
fi

echo ""
echo "Then ask: \"Find me a cheap flight from Shanghai to Tokyo\""
echo ""
