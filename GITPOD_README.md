# Gitpod Setup for Polkadot Smart Contract Development

This repository supports Gitpod for cloud-based development! Start developing Polkadot smart contracts directly in your browser without any local setup.

## Quick Start

1. **Open in Gitpod**: 
   ```
   https://gitpod.io/#https://github.com/paritytech/DevEx-DevRel
   ```
   
   Or use the button:
   [![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/paritytech/DevEx-DevRel)
   
   **Important**: Choose "Continue in Browser" instead of "Open in Desktop" when prompted.

2. **Interactive Setup**: 
   - When the workspace opens, you'll be prompted to choose between:
     - **Hardhat** (Option h): JavaScript/TypeScript based development
     - **Foundry** (Option f): Rust/Solidity based development
   - You'll then be prompted to enter a private key or generate a new one
   - All dependencies and tools will be installed automatically

3. **Get Test Tokens**: 
   Visit [Paseo Smart Contract faucet](https://faucet.polkadot.io/?parachain=1111) and paste your EVM address.

## Features

✅ Pre-configured development environment  
✅ Interactive choice between Hardhat and Foundry  
✅ Built-in Polkadot tools (subkey, substrate-node, eth-rpc)  
✅ VS Code extensions for Solidity development  
✅ Automatic keypair management  
✅ Binary downloads for substrate-node and eth-rpc  
✅ Template files and folder structure copying  

## Development Commands

### For Hardhat:
```bash
npx hardhat compile                     # Compile contracts
npx hardhat test                        # Run tests
npx hardhat ignition deploy ignition/modules/MyToken.ts --network polkadotHubTestnet
```

### For Foundry:
```bash
forge build                             # Build contracts
forge test                              # Run tests
forge create --rpc-url <RPC_URL> --private-key <KEY> src/Counter.sol:Counter
```

## Troubleshooting

### Gitpod opens local VS Code
- Always choose "Continue in Browser"
- Check preferences at https://gitpod.io/user/preferences

### No files appearing
- Wait for the initialization to complete
- Check the terminal output for any errors
- Ensure you're on the correct branch

### Keypair issues
- If keypair generation fails, restart the terminal
- You can always generate a key manually using `subkey generate --scheme ecdsa`

## Notes

- You can choose between Hardhat and Foundry during setup
- All tools run in a Linux AMD64 environment
- Binaries are downloaded to the `binaries/` folder
- Your keypair is stored in `~/.address.json`
- The setup uses the same DevContainer scripts for consistency
