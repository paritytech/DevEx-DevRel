# Gitpod Troubleshooting Guide

## Common Issues and Solutions

### Issue: No project files appearing

**Symptoms**: Only Gitpod configuration files visible, no contracts or package.json

**Solutions**:
1. Wait for the initialization to complete (check terminal output)
2. Ensure the branch with Gitpod configuration is pushed to GitHub
3. Try refreshing the workspace
4. Check the terminal for error messages

### Issue: Keypair setup fails with JSON errors

**Symptoms**: `parse error: Invalid numeric literal` messages

**Solutions**:
1. Delete `~/.address.json` if it exists: `rm ~/.address.json`
2. Restart the terminal
3. When prompted, either:
   - Press Enter to generate a new key
   - Paste a valid private key

### Issue: "Docker version required" error

**Symptoms**: Prompt to "Reopen in DevContainer"

**Solutions**:
- DO NOT click "Reopen in DevContainer"
- This is normal - Gitpod uses its own container system
- Just close the prompt and continue

### Issue: Gitpod opens in local VS Code

**Solutions**:
1. In the Gitpod dialog, choose "Continue in Browser"
2. Visit https://gitpod.io/user/preferences
3. Set default to "Browser"
4. Use direct URL: `https://gitpod.io/#https://github.com/paritytech/DevEx-DevRel`

### Issue: Commands not found

**Symptoms**: `npx: command not found` or similar

**Solutions**:
1. Wait for initialization to complete
2. Run `npm install` manually if needed
3. Ensure you're in the correct directory: `cd /workspace/DevEx-DevRel`

### Issue: Build errors during Docker image creation

**Solutions**:
1. Check Gitpod logs (click Gitpod logo → View Logs)
2. Ensure all files in Dockerfile COPY commands exist
3. Try stopping and restarting the workspace

## Quick Fixes

### Reset everything:
```bash
cd /workspace/DevEx-DevRel
rm -rf node_modules package-lock.json
npm install
```

### Regenerate keypair:
```bash
rm ~/.address.json
bash /usr/local/bin/gitpod-setup-keypair
```

### Manual Hardhat setup:
```bash
cd /workspace/DevEx-DevRel
npm init -y
npm install --save-dev hardhat @nomicfoundation/hardhat-toolbox
npx hardhat init
```

## Testing Your Setup

After successful setup, test with:
```bash
# Check Node.js
node --version

# Check Hardhat
npx hardhat --version

# Compile contracts
npx hardhat compile

# Run tests
npx hardhat test
```

## Getting Help

1. Check terminal output for specific errors
2. Look at Gitpod workspace logs
3. Ensure you're using the latest branch
4. Try opening in an incognito/private browser window
