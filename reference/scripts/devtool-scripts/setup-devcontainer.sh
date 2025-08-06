#!/bin/bash
set -e

WORKSPACE_DIR="/workspace"
PROJECT_DIR="/project"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Polkadot Hardhat DevContainer Initializer${NC}"
echo -e "${BLUE}============================================${NC}"

# Check if the mounted directory is empty or needs initialization
if [ -z "$(ls -A $PROJECT_DIR 2>/dev/null)" ] || [ ! -f "$PROJECT_DIR/package.json" ]; then
    echo -e "${YELLOW}📦 Initializing new Polkadot Hardhat project...${NC}"
    
    # Copy all template files
    echo -e "${GREEN}✓ Copying project template files...${NC}"
    cp -r $WORKSPACE_DIR/* $PROJECT_DIR/ 2>/dev/null || true
    cp $WORKSPACE_DIR/.gitignore $PROJECT_DIR/ 2>/dev/null || true
    
    # Change to project directory
    cd $PROJECT_DIR
    
    # Install dependencies
    echo -e "${GREEN}✓ Installing dependencies (this may take a few minutes)...${NC}"
    npm install
    
    # Update @parity/hardhat-polkadot to latest version
    echo -e "${GREEN}✓ Updating @parity/hardhat-polkadot to latest version...${NC}"
    npm install --save-dev @parity/hardhat-polkadot@latest
    
    echo -e "${GREEN}✨ Project initialized successfully!${NC}"
    echo -e "${BLUE}You can now:${NC}"
    echo -e "  - Create contracts in the ${GREEN}contracts/${NC} folder"
    echo -e "  - Write tests in the ${GREEN}test/${NC} folder"
    echo -e "  - Configure deployment in ${GREEN}ignition/modules/${NC}"
    echo -e "  - Run ${GREEN}npx hardhat compile${NC} to compile contracts"
    echo -e "  - Run ${GREEN}npx hardhat test${NC} to run tests"
    echo ""
else
    echo -e "${GREEN}✓ Existing project detected${NC}"
    cd $PROJECT_DIR
    
    # Check and update @parity/hardhat-polkadot if needed
    if npm list @parity/hardhat-polkadot &>/dev/null; then
        echo -e "${GREEN}✓ Checking for @parity/hardhat-polkadot updates...${NC}"
        # Get current and latest versions
        CURRENT_VERSION=$(npm list @parity/hardhat-polkadot --depth=0 --json 2>/dev/null | grep -oP '"version":\s*"\K[^"]+' | head -1)
        LATEST_VERSION=$(npm view @parity/hardhat-polkadot version 2>/dev/null)
        
        if [ "$CURRENT_VERSION" != "$LATEST_VERSION" ] && [ -n "$LATEST_VERSION" ]; then
            echo -e "${YELLOW}📦 Updating @parity/hardhat-polkadot from v${CURRENT_VERSION} to v${LATEST_VERSION}...${NC}"
            npm install --save-dev @parity/hardhat-polkadot@latest
            echo -e "${GREEN}✓ Updated successfully!${NC}"
        else
            echo -e "${GREEN}✓ @parity/hardhat-polkadot is already at the latest version (v${CURRENT_VERSION})${NC}"
        fi
    fi
fi

# Check if running under emulation
echo -e "${BLUE}🔧 Checking runtime environment...${NC}"

# Detect architecture
ARCH=$(uname -m)
EXPECTED_ARCH="x86_64"

# Check for QEMU/Rosetta emulation
if [ -f /proc/sys/fs/binfmt_misc/qemu-x86_64 ] || [ -f /proc/sys/fs/binfmt_misc/rosetta ]; then
    echo -e "${YELLOW}⚠️  Running under emulation (QEMU/Rosetta detected)${NC}"
    EMULATION_MODE="true"
elif [ "$ARCH" != "$EXPECTED_ARCH" ]; then
    echo -e "${YELLOW}⚠️  Architecture mismatch detected:${NC}"
    echo -e "${YELLOW}   - Current arch: $ARCH${NC}"
    echo -e "${YELLOW}   - Expected arch: $EXPECTED_ARCH${NC}"
    echo -e "${YELLOW}   - Likely running under emulation${NC}"
    EMULATION_MODE="true"
else
    echo -e "${GREEN}✓ Running on native $ARCH architecture${NC}"
    EMULATION_MODE="false"
fi

# Additional emulation checks
if [ -n "$DOCKER_DEFAULT_PLATFORM" ]; then
    echo -e "${BLUE}ℹ️  DOCKER_DEFAULT_PLATFORM is set to: $DOCKER_DEFAULT_PLATFORM${NC}"
fi

# Check Docker platform info
if command -v docker >/dev/null 2>&1; then
    DOCKER_INFO=$(docker version --format '{{.Server.Arch}}' 2>/dev/null || echo "unknown")
    echo -e "${BLUE}ℹ️  Docker server architecture: $DOCKER_INFO${NC}"
fi

# Log performance warning if under emulation
if [ "$EMULATION_MODE" = "true" ]; then
    echo -e "${YELLOW}⚠️  Performance Warning: Running x86_64 binaries under emulation may be slower${NC}"
    echo -e "${YELLOW}   Consider using native ARM64 binaries for better performance${NC}"
fi

echo ""

# Download Linux AMD64 binaries
echo -e "${BLUE}🔧 Setting up binaries...${NC}"

# Create binaries directory if it doesn't exist
mkdir -p $PROJECT_DIR/binaries

# Download binaries for Linux AMD64
cd $PROJECT_DIR/binaries

echo -e "${GREEN}Downloading Linux AMD64 binaries...${NC}"
wget -q -O substrate-node "http://releases.parity.io/substrate-node/polkadot-stable2555-rc5/x86_64-unknown-linux-gnu/substrate-node" || {
    echo -e "${YELLOW}Failed to download substrate-node, using dummy binary${NC}"
    echo "#!/bin/bash" > substrate-node
    echo "echo 'substrate-node dummy binary - download failed'" >> substrate-node
}

wget -q -O eth-rpc "http://releases.parity.io/eth-rpc/polkadot-stable2555-rc5/x86_64-unknown-linux-gnu/eth-rpc" || {
    echo -e "${YELLOW}Failed to download eth-rpc, using dummy binary${NC}"
    echo "#!/bin/bash" > eth-rpc
    echo "echo 'eth-rpc dummy binary - download failed'" >> eth-rpc
}

# Check binary architecture if file command is available
if command -v file >/dev/null 2>&1; then
    echo -e "${BLUE}ℹ️  Downloaded binary information:${NC}"
    file substrate-node 2>/dev/null | grep -q "ELF" && file substrate-node || echo "   substrate-node: not a valid binary"
    file eth-rpc 2>/dev/null | grep -q "ELF" && file eth-rpc || echo "   eth-rpc: not a valid binary"
fi

# Make binaries executable
chmod +x substrate-node eth-rpc

echo -e "${GREEN}✓ Binaries setup complete${NC}"

# Additional debugging for emulation mode
if [ "$EMULATION_MODE" = "true" ]; then
    echo -e "${YELLOW}⚠️  Note: x86_64 binaries will be executed under emulation${NC}"
    echo -e "${YELLOW}   If you encounter 'rosetta error', the binaries may not be compatible${NC}"
fi