# Gitpod Setup for Polkadot Smart Contract Development

This repository now supports Gitpod for cloud-based development! You can start developing Polkadot smart contracts directly in your browser without any local setup.

## Quick Start

1. **Open in Gitpod**: Click the button below or visit `https://gitpod.io/#https://github.com/paritytech/DevEx-DevRel`

   [![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/paritytech/DevEx-DevRel)

2. **Choose Your Environment**: When Gitpod starts, you'll be prompted to choose between:
   - **Hardhat** (Option 1): JavaScript/TypeScript based development
   - **Foundry** (Option 2): Rust/Solidity based development

3. **Set Up Your Keypair**: You'll be prompted to either:
   - Enter an existing Paseo private key
   - Press Enter to generate a new keypair

4. **Get Test Tokens**: Visit the [Paseo Smart Contract faucet](https://faucet.polkadot.io/?parachain=1111) and paste your EVM address to receive test tokens.

## Features

- ✅ Pre-configured development environment
- ✅ Automatic installation of all dependencies
- ✅ Built-in Polkadot tools (subkey, substrate-node, eth-rpc)
- ✅ VS Code extensions for Solidity development
- ✅ Support for both Hardhat and Foundry frameworks

## Development Commands

### For Hardhat Projects:
```bash
# Compile contracts
npx hardhat compile

# Run tests
npx hardhat test

# Deploy to Paseo testnet
npx hardhat ignition deploy ignition/modules/MyToken.ts --network polkadotHubTestnet
```

### For Foundry Projects:
```bash
# Build contracts
forge build

# Run tests
forge test

# Deploy contracts
forge create --rpc-url <RPC_URL> --private-key $SECRET src/Counter.sol:Counter
```

## Switching Between Environments

If you want to switch from Hardhat to Foundry (or vice versa):

1. Delete the current project files
2. Restart the Gitpod workspace
3. Choose the other option when prompted

## Troubleshooting

### "Docker version required" error
This is expected - Gitpod doesn't support DevContainers. Use the Gitpod configuration instead.

### Slow performance
The binaries run under x86_64 emulation on ARM machines, which may be slower. This is normal and doesn't affect functionality.

### Missing extensions
All necessary VS Code extensions are automatically installed. If any are missing, check the `.gitpod.yml` file for the complete list.

## Local Development

If you prefer local development with DevContainers, follow the instructions in the main [README.md](README.md).
