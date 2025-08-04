# Check if the mounted directory is empty or needs initialization
if [ -z "$(ls -A $PROJECT_DIR 2>/dev/null)" ] || [ ! -f "$PROJECT_DIR/package.json" ]; then
    echo -e "${YELLOW}📦 Initializing new Polkadot Hardhat project...${NC}"
    
    # Copy all template files
    echo -e "${GREEN}✓ Copying project template files...${NC}"
    cp -r $WORKSPACE_DIR/* $PROJECT_DIR/ 2>/dev/null || true
    cp $WORKSPACE_DIR/.gitignore $PROJECT_DIR/ 2>/dev/null || true
    
    # Change to project directory
    cd $PROJECT_DIR
    
    # Install dependencies
    echo -e "${GREEN}✓ Installing dependencies (this may take a few minutes)...${NC}"
    npm install
    
    # Update @parity/hardhat-polkadot to latest version
    echo -e "${GREEN}✓ Updating @parity/hardhat-polkadot to latest version...${NC}"
    npm install --save-dev @parity/hardhat-polkadot@latest
    
    echo -e "${GREEN}✨ Project initialized successfully!${NC}"
    echo -e "${BLUE}You can now:${NC}"
    echo -e "  - Create contracts in the ${GREEN}contracts/${NC} folder"
    echo -e "  - Write tests in the ${GREEN}test/${NC} folder"
    echo -e "  - Configure deployment in ${GREEN}ignition/modules/${NC}"
    echo -e "  - Run ${GREEN}npx hardhat compile${NC} to compile contracts"
    echo -e "  - Run ${GREEN}npx hardhat test${NC} to run tests"
    echo ""
else
    echo -e "${GREEN}✓ Existing project detected${NC}"
    cd $PROJECT_DIR
    
    # Check and update @parity/hardhat-polkadot if needed
    if npm list @parity/hardhat-polkadot &>/dev/null; then
        echo -e "${GREEN}✓ Checking for @parity/hardhat-polkadot updates...${NC}"
        # Get current and latest versions
        CURRENT_VERSION=$(npm list @parity/hardhat-polkadot --depth=0 --json 2>/dev/null | grep -oP '"version":\s*"\K[^"]+' | head -1)
        LATEST_VERSION=$(npm view @parity/hardhat-polkadot version 2>/dev/null)
        
        if [ "$CURRENT_VERSION" != "$LATEST_VERSION" ] && [ -n "$LATEST_VERSION" ]; then
            echo -e "${YELLOW}📦 Updating @parity/hardhat-polkadot from v${CURRENT_VERSION} to v${LATEST_VERSION}...${NC}"
            npm install --save-dev @parity/hardhat-polkadot@latest
            echo -e "${GREEN}✓ Updated successfully!${NC}"
        else
            echo -e "${GREEN}✓ @parity/hardhat-polkadot is already at the latest version (v${CURRENT_VERSION})${NC}"
        fi
    fi
fi