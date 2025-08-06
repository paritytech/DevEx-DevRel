FROM gitpod/workspace-full:latest

# Switch to root for installations
USER root

# Install required dependencies
RUN apt-get update && apt-get install -y \
    curl ca-certificates unzip help2man git \
    clang libssl-dev protobuf-compiler jq \
    && rm -rf /var/lib/apt/lists/*

# Install foundryup-polkadot
RUN curl -L https://raw.githubusercontent.com/paritytech/foundry-polkadot/refs/heads/master/foundryup/install | bash
# The installer puts foundryup-polkadot in /home/gitpod/.foundry/bin even when run as root
RUN /home/gitpod/.foundry/bin/foundryup-polkadot || true

# Download prebuilt subkey binary instead of building from source
RUN curl -L https://github.com/paritytech/polkadot-sdk/releases/download/stable2407/subkey -o /usr/local/bin/subkey && \
    chmod +x /usr/local/bin/subkey

# Create a temporary container from the pre-built image to extract template files
FROM ghcr.io/utkarshbhardwaj007/polkadot-hardhat-quickstart:latest as template-extractor
# This stage just exists to copy files from

# Continue with the main image
FROM gitpod/workspace-full:latest
USER root

# Install dependencies again in final stage
RUN apt-get update && apt-get install -y jq && rm -rf /var/lib/apt/lists/*

# Copy the installations from the first stage
COPY --from=0 /home/gitpod/.foundry /home/gitpod/.foundry
COPY --from=0 /usr/local/bin/subkey /usr/local/bin/subkey

# Copy template files from the pre-built image
COPY --from=template-extractor /workspace /workspace/template/hardhat

# Copy devtools scripts
COPY .devcontainer/smart-contracts/scripts/devtool-scripts /usr/local/bin/devtool-scripts
COPY .devcontainer/smart-contracts/scripts/devtools.sh /usr/local/bin/devtools
RUN chmod +x /usr/local/bin/devtools /usr/local/bin/devtool-scripts/*

# Fix ownership for gitpod user's directories
RUN chown -R gitpod:gitpod /home/gitpod/.foundry || true

# Switch back to gitpod user
USER gitpod

# Add wasm target for Rust (Rust is pre-installed in gitpod/workspace-full)
RUN rustup target add wasm32-unknown-unknown && \
    rustup component add rust-src

# Make tools available to gitpod user
ENV PATH="/home/gitpod/.foundry/bin:$PATH"
