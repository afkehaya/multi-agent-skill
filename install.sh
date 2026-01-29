#!/bin/bash
# Multi-Agent Skill Installer for Claude Code
#
# Usage:
#   ./install.sh           # Install globally (~/.claude/)
#   ./install.sh --project # Install to current project (./.claude/)
#   ./install.sh --help    # Show help

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

show_help() {
    echo "Multi-Agent Skill Installer"
    echo ""
    echo "Usage:"
    echo "  ./install.sh           Install globally to ~/.claude/"
    echo "  ./install.sh --project Install to current project's .claude/"
    echo "  ./install.sh --help    Show this help message"
    echo ""
    echo "After installation:"
    echo "  1. Add subagent definitions from settings.template.json to your settings"
    echo "  2. Run /multi-agent init in any project to get started"
}

install_skill() {
    local target_dir="$1"
    local install_type="$2"

    echo -e "${GREEN}Installing multi-agent skill to ${target_dir}${NC}"

    # Create directories
    mkdir -p "${target_dir}/commands"
    mkdir -p "${target_dir}/skills/multi-agent/templates"

    # Copy files
    cp "${SCRIPT_DIR}/.claude/commands/multi-agent.md" "${target_dir}/commands/"
    cp "${SCRIPT_DIR}/.claude/skills/multi-agent/skill.md" "${target_dir}/skills/multi-agent/"
    cp "${SCRIPT_DIR}/.claude/skills/multi-agent/templates/"* "${target_dir}/skills/multi-agent/templates/"

    echo -e "${GREEN}✓ Skill files installed${NC}"

    # Check for existing settings
    local settings_file="${target_dir}/settings.json"
    if [ "$install_type" = "project" ]; then
        settings_file="${target_dir}/settings.local.json"
    fi

    if [ -f "$settings_file" ]; then
        echo -e "${YELLOW}⚠ Settings file exists at ${settings_file}${NC}"
        echo "  Please manually merge subagent definitions from settings.template.json"
    else
        echo -e "${YELLOW}! No settings file found at ${settings_file}${NC}"
        echo "  Create one and add subagent definitions from settings.template.json"
    fi

    echo ""
    echo -e "${GREEN}Installation complete!${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Add subagents from settings.template.json to your Claude settings"
    echo "  2. Run: /multi-agent init"
}

# Parse arguments
case "${1:-}" in
    --help|-h)
        show_help
        exit 0
        ;;
    --project|-p)
        if [ ! -d ".git" ]; then
            echo -e "${RED}Error: Not in a git repository root${NC}"
            echo "Run this command from your project's root directory"
            exit 1
        fi
        install_skill "./.claude" "project"
        ;;
    "")
        install_skill "${HOME}/.claude" "global"
        ;;
    *)
        echo -e "${RED}Unknown option: $1${NC}"
        show_help
        exit 1
        ;;
esac
