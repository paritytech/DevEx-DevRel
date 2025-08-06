#!/bin/bash

# Gitpod-specific keypair setup script
# Handles edge cases better than the generic devtools version

export WORKSPACE_DIR="/workspace"
export PROJECT_DIR="/workspace/DevEx-DevRel"

# Source the constants
source /usr/local/bin/devtool-scripts/constants.sh 2>/dev/null || {
    # Fallback if constants not available
    BOLD='\033[1m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    RED='\033[31m'
    GREY='\033[30m'
    BLUE='\033[0;34m'
    STYLE_END='\033[0m'
}

cd "$PROJECT_DIR" 2>/dev/null || cd /workspace/DevEx-DevRel || true

# Check if the private key is already set
if [ -s ~/.address.json ]; then
    echo -e "${GREEN}✓ Paseo deployment keypair configured${STYLE_END}"
else
    echo -e "${YELLOW}⚠️  No private key found for deployment${STYLE_END}"
    read -s -p "Paseo private key (leave blank to generate new): " SECRET_INPUT
    echo ""
    
    if [ -z "$SECRET_INPUT" ]; then
        # Generate new keypair
        if command -v subkey &> /dev/null && subkey --version &> /dev/null; then
            subkey generate --scheme ecdsa --network polkadot --output-type json > ~/.address.json
        else
            # Fallback: generate with openssl
            PRIVATE_KEY="0x$(openssl rand -hex 32)"
            echo "{\"secretSeed\": \"$PRIVATE_KEY\", \"ss58PublicKey\": \"Generated with openssl\"}" > ~/.address.json
        fi
    else
        # Use provided key
        if command -v subkey &> /dev/null && subkey --version &> /dev/null; then
            subkey inspect --scheme ecdsa "$SECRET_INPUT" --network polkadot --output-type json > ~/.address.json 2>/dev/null || {
                echo "{\"secretSeed\": \"$SECRET_INPUT\", \"ss58PublicKey\": \"User provided\"}" > ~/.address.json
            }
        else
            echo "{\"secretSeed\": \"$SECRET_INPUT\", \"ss58PublicKey\": \"User provided\"}" > ~/.address.json
        fi
    fi
fi

# Safely extract keypair details
PUBLIC_ADDRESS=$(jq -r '.ss58PublicKey' ~/.address.json 2>/dev/null || echo "N/A")
SECRET=$(jq -r '.secretSeed' ~/.address.json 2>/dev/null || echo "N/A")

# Calculate EVM address if possible
EVM_ADDRESS="N/A"
if [ -f "package.json" ] && [ "$SECRET" != "N/A" ]; then
    # Check if ethers is installed
    if npm list ethers &>/dev/null 2>&1; then
        EVM_ADDRESS=$(node -e 'const {Wallet}=require("ethers"); console.log(new Wallet(process.argv[1]).address)' "$SECRET" 2>/dev/null || echo "N/A")
        # Add keypair to hardhat config
        echo "$SECRET" | npx hardhat vars set TEST_ACC_PRIVATE_KEY >/dev/null 2>&1 || true
    fi
fi

# Display welcome message
echo ""
echo -e "${BLUE}🎉 Welcome to Polkadot Smart Contract Development!${STYLE_END}"
echo -e "${BLUE}==================================================${STYLE_END}"
echo ""
echo -e "EVM Address: ${BOLD}${EVM_ADDRESS}${STYLE_END}"
echo -e "Substrate Address: ${BOLD}${PUBLIC_ADDRESS}${STYLE_END}"
echo ""
echo -e "${RED}Note:${STYLE_END} ${GREY}Do not use this address for anything of real value${STYLE_END}"
echo ""
echo -e "💰 Get test tokens at: ${BLUE}https://faucet.polkadot.io/?parachain=1111${STYLE_END}"
echo ""

# Show available commands
if [ -f "hardhat.config.ts" ] || [ -f "hardhat.config.js" ]; then
    echo -e "${GREEN}📚 Hardhat Commands:${STYLE_END}"
    echo "  npx hardhat compile       - Compile contracts"
    echo "  npx hardhat test          - Run tests"
    echo "  npx hardhat ignition deploy ignition/modules/MyToken.ts --network polkadotHubTestnet"
elif [ -f "foundry.toml" ]; then
    echo -e "${GREEN}📚 Foundry Commands:${STYLE_END}"
    echo "  forge build               - Build contracts"
    echo "  forge test                - Run tests"
    echo "  forge create              - Deploy contracts"
else
    echo -e "${YELLOW}ℹ️  Project not yet initialized. Files will be set up shortly...${STYLE_END}"
fi
echo ""

# Keep terminal open
exec bash
