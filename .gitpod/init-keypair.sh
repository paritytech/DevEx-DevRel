#!/bin/bash

# Keypair setup script for Gitpod (mimics DevContainer behavior)

# Text styling
BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[31m'
GREY='\033[30m'
STYLE_END='\033[0m'

# Check and setup private key if needed
cd /workspace/DevEx-DevRel 2>/dev/null || true

# Check if the private key is already set
if [ -s ~/.address.json ]; then
    echo -e "${GREEN}✓ Paseo deployment keypair configured${STYLE_END}"
else
    echo -e "${YELLOW}⚠️  No private key found for deployment${STYLE_END}"
    read -s -p "Polkadot private key for deployment (leave blank to generate new): " SECRET_INPUT
    echo ""
    
    if [ -z "$SECRET_INPUT" ]; then
        # Check if subkey is available
        if command -v subkey &> /dev/null && subkey --version &> /dev/null; then
            subkey generate --scheme ecdsa --network polkadot --output-type json > ~/.address.json
        else
            # Fallback to generating with openssl
            PRIVATE_KEY="0x$(openssl rand -hex 32)"
            echo "{\"secretSeed\": \"$PRIVATE_KEY\", \"ss58PublicKey\": \"Generated offline\"}" > ~/.address.json
        fi
    else
        if command -v subkey &> /dev/null && subkey --version &> /dev/null; then
            subkey inspect --scheme ecdsa "$SECRET_INPUT" --network polkadot --output-type json > ~/.address.json
        else
            echo "{\"secretSeed\": \"$SECRET_INPUT\", \"ss58PublicKey\": \"User provided\"}" > ~/.address.json
        fi
    fi
fi

# Capture keypair details
PUBLIC_ADDRESS=$(jq -r '.ss58PublicKey' ~/.address.json 2>/dev/null || echo "N/A")
SECRET=$(jq -r '.secretSeed' ~/.address.json 2>/dev/null || echo "N/A")

# Calculate EVM address if ethers is available
if [ -f "package.json" ] && npm list ethers &>/dev/null 2>&1; then
    EVM_ADDRESS=$(node -e 'const {Wallet}=require("ethers"); console.log(new Wallet(process.argv[1]).address)' "$SECRET" 2>/dev/null || echo "N/A")
    # Add keypair to hardhat config
    echo "$SECRET" | npx hardhat vars set TEST_ACC_PRIVATE_KEY >/dev/null 2>&1 || true
else
    EVM_ADDRESS="Run setup first to see EVM address"
fi

# Output Message
echo -e "
EVM Address: ${BOLD}${EVM_ADDRESS}${STYLE_END}
${BOLD}${RED}Note:${STYLE_END} ${GREY}Do not use this address for anything of real value${STYLE_END}

💰 Get test tokens at: https://faucet.polkadot.io/?parachain=1111
"

# Show available commands
echo ""
echo "📚 Available Commands:"
echo ""
if [ -f "hardhat.config.ts" ]; then
  echo "  npx hardhat compile       - Compile contracts"
  echo "  npx hardhat test          - Run tests"
  echo "  npx hardhat ignition deploy ignition/modules/MyToken.ts --network polkadotHubTestnet"
elif [ -f "foundry.toml" ]; then
  echo "  forge build               - Build contracts"
  echo "  forge test                - Run tests"
  echo "  forge create              - Deploy contracts"
else
  echo "  Run the setup first to initialize a Hardhat or Foundry project"
fi
echo ""
