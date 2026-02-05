#!/bin/bash
# ============================================
# Social Content Agent - Deployment Script
# Deploys workspace files and config to OpenClaw
# Run this from WSL2: bash scripts/deploy.sh
# ============================================

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "=========================================="
echo "  Social Content Agent - Deploy"
echo "=========================================="
echo ""

# Determine the script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
OPENCLAW_DIR="$HOME/.openclaw"
WORKSPACE_DIR="$OPENCLAW_DIR/workspace"

# Step 1: Check prerequisites
echo -e "${YELLOW}[1/6] Checking prerequisites...${NC}"

if ! command -v node &> /dev/null; then
    echo -e "${RED}Error: Node.js not found. Install Node.js 22+ first.${NC}"
    echo "  Run: curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash - && sudo apt-get install -y nodejs"
    exit 1
fi

NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 22 ]; then
    echo -e "${RED}Error: Node.js 22+ required (found v$(node -v))${NC}"
    exit 1
fi
echo -e "  Node.js $(node -v) ${GREEN}OK${NC}"

if ! command -v openclaw &> /dev/null; then
    echo -e "${YELLOW}  OpenClaw not found. Installing...${NC}"
    npm install -g openclaw@latest
fi
echo -e "  OpenClaw $(openclaw --version 2>/dev/null || echo 'installed') ${GREEN}OK${NC}"

# Step 2: Check environment variables
echo ""
echo -e "${YELLOW}[2/6] Checking environment...${NC}"

if [ ! -f "$OPENCLAW_DIR/.env" ]; then
    echo -e "${YELLOW}  Creating $OPENCLAW_DIR/.env from template...${NC}"
    mkdir -p "$OPENCLAW_DIR"
    cp "$PROJECT_ROOT/.env.example" "$OPENCLAW_DIR/.env"
    echo -e "${RED}  IMPORTANT: Edit $OPENCLAW_DIR/.env with your actual API keys!${NC}"
    echo "  - OPENAI_API_KEY: Your OpenAI API key"
    echo "  - TELEGRAM_BOT_TOKEN: Your Telegram bot token from @BotFather"
    echo ""
    echo "  After editing, run this script again."
    exit 1
else
    echo -e "  .env file found ${GREEN}OK${NC}"
fi

# Step 3: Deploy configuration
echo ""
echo -e "${YELLOW}[3/6] Deploying configuration...${NC}"
mkdir -p "$OPENCLAW_DIR"
cp "$PROJECT_ROOT/config/openclaw.json5" "$OPENCLAW_DIR/openclaw.json"
echo -e "  Config deployed to $OPENCLAW_DIR/openclaw.json ${GREEN}OK${NC}"

# Step 4: Deploy workspace files
echo ""
echo -e "${YELLOW}[4/6] Deploying workspace...${NC}"
mkdir -p "$WORKSPACE_DIR"
mkdir -p "$WORKSPACE_DIR/memory"
mkdir -p "$WORKSPACE_DIR/skills"

# Copy workspace markdown files
for file in AGENTS.md SOUL.md USER.md IDENTITY.md TOOLS.md MEMORY.md; do
    if [ -f "$PROJECT_ROOT/workspace/$file" ]; then
        cp "$PROJECT_ROOT/workspace/$file" "$WORKSPACE_DIR/$file"
        echo "  Deployed $file"
    fi
done

# Copy skills
cp -r "$PROJECT_ROOT/workspace/skills/"* "$WORKSPACE_DIR/skills/"
echo "  Deployed skills/"

# Copy extensions
mkdir -p "$WORKSPACE_DIR/.openclaw/extensions"
cp -r "$PROJECT_ROOT/workspace/.openclaw/extensions/"* "$WORKSPACE_DIR/.openclaw/extensions/"
echo "  Deployed extensions/"

echo -e "  Workspace deployed ${GREEN}OK${NC}"

# Step 5: Install plugin
echo ""
echo -e "${YELLOW}[5/6] Installing plugin...${NC}"
PLUGIN_DIR="$WORKSPACE_DIR/.openclaw/extensions/social-content-tool"
if [ -d "$PLUGIN_DIR" ]; then
    openclaw plugins install -l "$PLUGIN_DIR" 2>/dev/null || {
        echo -e "${YELLOW}  Plugin install via CLI skipped (may need manual setup)${NC}"
    }
    echo -e "  Plugin installed ${GREEN}OK${NC}"
fi

# Step 6: Validate
echo ""
echo -e "${YELLOW}[6/6] Validating setup...${NC}"
openclaw doctor 2>/dev/null || {
    echo -e "${YELLOW}  openclaw doctor returned warnings (review above)${NC}"
}

echo ""
echo "=========================================="
echo -e "  ${GREEN}Deployment complete!${NC}"
echo "=========================================="
echo ""
echo "Next steps:"
echo "  1. Edit $OPENCLAW_DIR/openclaw.json"
echo "     - Replace YOUR_TELEGRAM_USER_ID with your Telegram user ID"
echo "  2. Start the agent:"
echo "     openclaw gateway"
echo "  3. DM your bot on Telegram and start creating content!"
echo ""
echo "Useful commands:"
echo "  openclaw gateway        - Start the agent"
echo "  openclaw channels status - Check Telegram connection"
echo "  openclaw skills list    - List loaded skills"
echo "  openclaw logs --follow  - Watch agent logs"
echo ""
