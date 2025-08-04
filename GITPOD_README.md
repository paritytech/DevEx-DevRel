# Gitpod Setup for Polkadot Smart Contract Development

This repository now supports Gitpod for cloud-based development! You can start developing Polkadot smart contracts directly in your browser without any local setup.

## Quick Start

1. **Open in Gitpod**: Use one of these methods:
   
   **Option A - Direct Browser Link (Recommended):**
   ```
   https://gitpod.io/#https://github.com/paritytech/DevEx-DevRel
   ```
   
   **Option B - Gitpod Button:**
   [![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/paritytech/DevEx-DevRel)
   
   **Important**: Make sure you're opening in browser mode, not desktop VSCode. If prompted to "Open in Desktop", choose "Continue in Browser" instead.

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

### Gitpod opens local VSCode instead of browser
If Gitpod tries to open VSCode locally with SSH:

1. **In the Gitpod dialog**, choose "Continue in Browser" instead of "Open in Desktop"
2. **Check your Gitpod settings**: Go to https://gitpod.io/user/preferences and ensure "Open in Browser" is selected
3. **Use the direct URL**: Always use the format `https://gitpod.io/#https://github.com/paritytech/DevEx-DevRel`
4. **Clear browser cache** if the issue persists

### "Docker version required" or "Reopen in DevContainer" error
This happens when Gitpod tries to use DevContainer configuration. Solutions:

1. **DO NOT** click "Reopen in DevContainer" - this won't work in Gitpod
2. The repository includes `.gitpodignore` to prevent this, but if it still happens:
   - Close the DevContainer prompt
   - Use the terminal and file explorer directly
   - The Gitpod configuration handles all setup automatically

### Slow performance
The binaries run under x86_64 emulation on ARM machines, which may be slower. This is normal and doesn't affect functionality.

### Missing extensions
All necessary VS Code extensions are automatically installed. If any are missing, check the `.gitpod.yml` file for the complete list.

## Company/Team Gitpod Setup

If using a company Gitpod account:

1. Share this direct link with your team: `https://gitpod.io/#https://github.com/paritytech/DevEx-DevRel`
2. Ensure team members select "Continue in Browser" when prompted
3. Consider setting organization-wide preferences to default to browser mode

## Local Development

If you prefer local development with DevContainers, follow the instructions in the main [README.md](README.md).
