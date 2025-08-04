#!/usr/bin/env bash
set -euo pipefail

RPC="https://testnet-passet-hub-eth-rpc.polkadot.io"

SECRET=$(jq -r '.secretSeed' ~/.address.json)
ADDR=$(node -e 'const {Wallet}=require("ethers"); console.log(new Wallet(process.argv[1]).address)' "$SECRET")
HEX=$(curl -s -H 'content-type: application/json' -X POST "$RPC" \
  --data "{\"jsonrpc\":\"2.0\",\"method\":\"eth_getBalance\",\"params\":[\"$ADDR\",\"latest\"],\"id\":1}" \
  | jq -r '.result')

# Convert hex wei -> PAS; EVM uses 18 decimals
BAL=$(node -e '
  const {formatUnits}=require("ethers");
  const x=BigInt(process.argv[1]);
  let s=formatUnits(x,18);              // string, e.g. "4994.976445952200000000"
  s=s.replace(/(\.\d*?[1-9])0+$/,"$1")  // drop trailing zeros
       .replace(/\.0+$/,"")             // drop ".0"
       .replace(/\.$/,"");              // safety
  console.log(s);
' "$HEX")

# Rich text
GREEN='\033[1;32m'
RESET='\033[0m'

# Output message
echo -e "Balance: ${GREEN}$BAL PAS${RESET}"