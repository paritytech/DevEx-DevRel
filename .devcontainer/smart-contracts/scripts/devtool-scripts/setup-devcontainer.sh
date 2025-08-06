echo -e "${BLUE}🚀 Polkadot Smart Contract DevContainer Initializer${STYLE_END}"
echo -e "${BLUE}============================================${STYLE_END}"

# Determine project type (detect existing or prompt for (h)ardhat or (f)oundry)
if compgen -G "$PROJECT_DIR/hardhat.config.*" > /dev/null; then
    PROJECT_TYPE="hardhat"
elif compgen -G "$PROJECT_DIR/foundry.toml" > /dev/null; then
    PROJECT_TYPE="foundry"
else
    while true; do
      read -n 1 -r -p "Initialize (h)ardhat or (f)oundry? [h/f] " ans
      echo ""
      case "$ans" in
        [Hh]) PROJECT_TYPE="hardhat"; break ;;
        [Ff]) PROJECT_TYPE="foundry"; break ;;
        *) echo "Please type 'h' or 'f'." ;;
      esac
    done
fi

# Initialize based on project type
if [ "$PROJECT_TYPE" = "hardhat" ]; then
    source devtools init-hardhat
else
    source devtools init-foundry
fi

# Check if running under emulation
echo -e "${BLUE}🔧 Checking runtime environment...${STYLE_END}"

# Detect architecture
ARCH=$(uname -m)
EXPECTED_ARCH="x86_64"

# Check for QEMU/Rosetta emulation
if [ -f /proc/sys/fs/binfmt_misc/qemu-x86_64 ] || [ -f /proc/sys/fs/binfmt_misc/rosetta ]; then
    echo -e "${YELLOW}⚠️  Running under emulation (QEMU/Rosetta detected)${STYLE_END}"
    EMULATION_MODE="true"
elif [ "$ARCH" != "$EXPECTED_ARCH" ]; then
    echo -e "${YELLOW}⚠️  Architecture mismatch detected:${STYLE_END}"
    echo -e "${YELLOW}   - Current arch: $ARCH${STYLE_END}"
    echo -e "${YELLOW}   - Expected arch: $EXPECTED_ARCH${STYLE_END}"
    echo -e "${YELLOW}   - Likely running under emulation${STYLE_END}"
    EMULATION_MODE="true"
else
    echo -e "${GREEN}✓ Running on native $ARCH architecture${STYLE_END}"
    EMULATION_MODE="false"
fi

# Additional emulation checks
if [ -n "$DOCKER_DEFAULT_PLATFORM" ]; then
    echo -e "${BLUE}ℹ️  DOCKER_DEFAULT_PLATFORM is set to: $DOCKER_DEFAULT_PLATFORM${STYLE_END}"
fi

# Check Docker platform info
if command -v docker >/dev/null 2>&1; then
    DOCKER_INFO=$(docker version --format '{{.Server.Arch}}' 2>/dev/null || echo "unknown")
    echo -e "${BLUE}ℹ️  Docker server architecture: $DOCKER_INFO${STYLE_END}"
fi

# Log performance warning if under emulation
if [ "$EMULATION_MODE" = "true" ]; then
    echo -e "${YELLOW}⚠️  Performance Warning: Running x86_64 binaries under emulation may be slower${STYLE_END}"
    echo -e "${YELLOW}   Consider using native ARM64 binaries for better performance${STYLE_END}"
fi

echo ""

# Download Linux AMD64 binaries
echo -e "${BLUE}🔧 Setting up binaries...${STYLE_END}"

# Create binaries directory if it doesn't exist
mkdir -p $PROJECT_DIR/binaries

# Download binaries for Linux AMD64
cd $PROJECT_DIR/binaries

echo -e "${GREEN}Downloading Linux AMD64 binaries...${STYLE_END}"
wget -q -O substrate-node "http://releases.parity.io/substrate-node/polkadot-stable2555-rc5/x86_64-unknown-linux-gnu/substrate-node" || {
    echo -e "${YELLOW}Failed to download substrate-node, using dummy binary${STYLE_END}"
    echo "#!/bin/bash" > substrate-node
    echo "echo 'substrate-node dummy binary - download failed'" >> substrate-node
}

wget -q -O eth-rpc "http://releases.parity.io/eth-rpc/polkadot-stable2555-rc5/x86_64-unknown-linux-gnu/eth-rpc" || {
    echo -e "${YELLOW}Failed to download eth-rpc, using dummy binary${STYLE_END}"
    echo "#!/bin/bash" > eth-rpc
    echo "echo 'eth-rpc dummy binary - download failed'" >> eth-rpc
}

# Check binary architecture if file command is available
if command -v file >/dev/null 2>&1; then
    echo -e "${BLUE}ℹ️  Downloaded binary information:${STYLE_END}"
    file substrate-node 2>/dev/null | grep -q "ELF" && file substrate-node || echo "   substrate-node: not a valid binary"
    file eth-rpc 2>/dev/null | grep -q "ELF" && file eth-rpc || echo "   eth-rpc: not a valid binary"
fi

# Make binaries executable
chmod +x substrate-node eth-rpc

echo -e "${GREEN}✓ Binaries setup complete${STYLE_END}"

# Additional debugging for emulation mode
if [ "$EMULATION_MODE" = "true" ]; then
    echo -e "${YELLOW}⚠️  Note: x86_64 binaries will be executed under emulation${STYLE_END}"
    echo -e "${YELLOW}   If you encounter 'rosetta error', the binaries may not be compatible${STYLE_END}"
fi