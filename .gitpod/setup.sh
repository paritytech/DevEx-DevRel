#!/bin/bash

# Gitpod-specific setup script (non-interactive)
# This wraps the devtools scripts to work in Gitpod's environment

export WORKSPACE_DIR="/workspace"
export PROJECT_DIR="/workspace/DevEx-DevRel"

# Source the constants
source /usr/local/bin/devtool-scripts/constants.sh

echo -e "${BLUE}🚀 Initializing Polkadot Development Environment for Gitpod${STYLE_END}"
echo -e "${BLUE}============================================${STYLE_END}"

cd "$PROJECT_DIR" || exit 1

# Check if project is already initialized
if compgen -G "$PROJECT_DIR/hardhat.config.*" > /dev/null; then
    echo -e "${GREEN}✅ Existing Hardhat project detected${STYLE_END}"
    npm install
elif compgen -G "$PROJECT_DIR/foundry.toml" > /dev/null; then
    echo -e "${GREEN}✅ Existing Foundry project detected${STYLE_END}"
else
    # Default to Hardhat for non-interactive setup
    # Users can change this later if needed
    echo -e "${YELLOW}📦 Setting up new Hardhat project (default for Gitpod)${STYLE_END}"
    echo -e "${BLUE}ℹ️  To use Foundry instead, delete all files and restart the workspace${STYLE_END}"
    
    # Copy template files
    if [ -d "/workspace/template/hardhat" ]; then
        echo -e "${GREEN}✓ Copying template files...${STYLE_END}"
        cp -r /workspace/template/hardhat/* "$PROJECT_DIR/" 2>/dev/null || true
        cp /workspace/template/hardhat/.gitignore "$PROJECT_DIR/" 2>/dev/null || true
    fi
    
    # Ensure package.json exists
    if [ ! -f "$PROJECT_DIR/package.json" ]; then
        cd "$PROJECT_DIR"
        npm init -y
    fi
    
    # Install dependencies
    cd "$PROJECT_DIR"
    echo -e "${GREEN}✓ Installing dependencies...${STYLE_END}"
    npm install --save-dev hardhat @nomicfoundation/hardhat-toolbox @parity/hardhat-polkadot@latest typescript @types/node @openzeppelin/contracts ethers
    
    # Create basic project structure if not from template
    mkdir -p contracts test ignition/modules
    
    echo -e "${GREEN}✨ Hardhat project initialized!${STYLE_END}"
fi

# Download binaries
echo -e "${BLUE}🔧 Setting up binaries...${STYLE_END}"
mkdir -p "$PROJECT_DIR/binaries"
cd "$PROJECT_DIR/binaries"

echo -e "${GREEN}Downloading Linux AMD64 binaries...${STYLE_END}"
wget -q -O substrate-node "http://releases.parity.io/substrate-node/polkadot-stable2555-rc5/x86_64-unknown-linux-gnu/substrate-node" || {
    echo -e "${YELLOW}Failed to download substrate-node${STYLE_END}"
}

wget -q -O eth-rpc "http://releases.parity.io/eth-rpc/polkadot-stable2555-rc5/x86_64-unknown-linux-gnu/eth-rpc" || {
    echo -e "${YELLOW}Failed to download eth-rpc${STYLE_END}"
}

chmod +x substrate-node eth-rpc 2>/dev/null || true

cd "$PROJECT_DIR"
echo -e "${GREEN}✅ Environment setup complete!${STYLE_END}"
