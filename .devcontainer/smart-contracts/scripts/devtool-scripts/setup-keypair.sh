#!/bin/bash

# Text styling
BOLD='\033[1m'
ITALIC='\033[3m'
BOLD_WHITE='\033[97m'
BLUE='\033[34m'
GREEN='\033[32m'
RED='\033[31m'
YELLOW='\033[33m'
GREY='\033[30m'
STYLE_END='\033[0m'
LINK_START='\033]8;;https://faucet.polkadot.io/?parachain=1111\033\\'
LINK_END='\033]8;;\033\\'

# Check and setup private key if needed
cd /project 2>/dev/null || true

# Check if the private key is already set
if [ -s ~/.address.json ]; then
    echo -e "\033[0;32m✓ Paseo deployment keypair configured \033[0m"
else
    echo -e "\033[1;33m⚠️  No private key found for deployment\033[0m"
    read -s -p "Paseo Secret (leave blank to generate new):" SECRET_INPUT
    echo ""
    if [ -z "$SECRET_INPUT" ]; then
        subkey generate --scheme ecdsa --network polkadot --output-type json > ~/.address.json
    else
        subkey inspect --scheme ecdsa $SECRET_INPUT --network polkadot --output-type json > ~/.address.json
    fi
fi

# Capture keypair
PUBLIC_ADDRESS=$(jq -r '.ss58PublicKey' ~/.address.json)
SECRET=$(jq -r '.secretSeed' ~/.address.json)
EVM_ADDRESS=$(node -e 'const {Wallet}=require("ethers"); console.log(new Wallet(process.argv[1]).address)' "$SECRET")

# Add keypair to hardhat config | TODO! Check if we're in hardhat or foundry
echo "$SECRET" | npx hardhat vars set TEST_ACC_PRIVATE_KEY >/dev/null 2>&1

# Output Message
echo -e "

EVM Address: ${BOLD}${EVM_ADDRESS}${STYLE_END}
${BOLD}${ITALIC}${RED}Note:${STYLE_END} ${ITALIC}${GREY}Do not use this address for anything of real value${STYLE_END}

$(bash devtools check-balance)
Paste the address into the ${LINK_START}${BLUE}Paseo Smart Contract faucet${LINK_END}${STYLE_END} to receive tokens for testing your contracts!

"
exec /bin/bash -c "exec /bin/bash"