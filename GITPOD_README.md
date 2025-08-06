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

2. **Automatic Setup**: 
   - Gitpod will automatically set up a Hardhat project by default
   - You'll be prompted to enter a private key or generate a new one
   - All dependencies and tools are pre-installed

3. **Get Test Tokens**: 
   Visit [Paseo Smart Contract faucet](https://faucet.polkadot.io/?parachain=1111) and paste your EVM address.

## Features

✅ Pre-configured development environment  
✅ Automatic Hardhat project setup (default)  
✅ Built-in Polkadot tools (subkey, substrate-node, eth-rpc)  
✅ VS Code extensions for Solidity development  
✅ Automatic keypair management  

## Development Commands

### Hardhat (Default):
```bash
npx hardhat compile                     # Compile contracts
npx hardhat test                        # Run tests
npx hardhat ignition deploy ignition/modules/MyToken.ts --network polkadotHubTestnet
```

### Switching to Foundry:
If you prefer Foundry, delete all files, restart the workspace, and manually run:
```bash
forge init --no-git --force
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

- The default setup uses Hardhat for simplicity
- All tools run in a Linux AMD64 environment
- Binaries are downloaded to the `binaries/` folder
- Your keypair is stored in `~/.address.json`
