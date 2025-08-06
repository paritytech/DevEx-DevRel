#!/bin/bash

# Simple keypair initialization script for Gitpod

if [ ! -s ~/.address.json ]; then
  echo "⚠️  No private key found for deployment"
  echo ""
  read -s -p "Enter your Paseo private key (or press Enter to generate a new one): " SECRET_INPUT
  echo ""
  
  if [ -z "$SECRET_INPUT" ]; then
    echo "Generating new keypair..."
    # Generate a random private key
    PRIVATE_KEY="0x$(openssl rand -hex 32)"
    echo "{\"secretSeed\": \"$PRIVATE_KEY\", \"ss58PublicKey\": \"Generated offline\"}" > ~/.address.json
    echo "✅ New keypair generated"
  else
    echo "{\"secretSeed\": \"$SECRET_INPUT\", \"ss58PublicKey\": \"User provided\"}" > ~/.address.json
    echo "✅ Keypair configured"
  fi
fi

# Show the private key for reference
if [ -f ~/.address.json ]; then
  SECRET=$(jq -r '.secretSeed' ~/.address.json 2>/dev/null || echo "N/A")
  echo ""
  echo "🔑 Private Key available in ~/.address.json"
  echo "💰 Get test tokens at: https://faucet.polkadot.io/?parachain=1111"
fi
