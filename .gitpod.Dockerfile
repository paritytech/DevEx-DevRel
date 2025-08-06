FROM gitpod/workspace-full:latest

# Switch to root for installations
USER root

# Install Rust and required dependencies
RUN apt-get update && apt-get install -y \
    curl ca-certificates unzip help2man git \
    clang libssl-dev protobuf-compiler jq \
    && rm -rf /var/lib/apt/lists/*

# Install Rust toolchain
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
ENV PATH="/root/.cargo/bin:$PATH"

# Add wasm target and rust-src
RUN rustup target add wasm32-unknown-unknown && \
    rustup component add rust-src

# Install subkey
RUN cargo install --force subkey --git https://github.com/paritytech/polkadot-sdk --tag polkadot-stable2503-6

# Install foundryup-polkadot
RUN curl -L https://raw.githubusercontent.com/paritytech/foundry-polkadot/refs/heads/master/foundryup/install | bash
# The installer puts foundryup-polkadot in /home/gitpod/.foundry/bin even when run as root
RUN /home/gitpod/.foundry/bin/foundryup-polkadot || true

# Add foundry to PATH
ENV PATH="/home/gitpod/.foundry/bin:$PATH"

# Create a temporary container from the pre-built image to extract template files
FROM ghcr.io/utkarshbhardwaj007/polkadot-hardhat-quickstart:latest as template-extractor
# This stage just exists to copy files from

# Continue with the main image
FROM gitpod/workspace-full:latest
USER root

# Copy all the installations from the first stage
COPY --from=0 /root/.cargo /root/.cargo
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

# Set Rust environment for gitpod user
RUN echo 'source $HOME/.cargo/env' >> ~/.bashrc

# Make tools available to gitpod user
ENV PATH="/home/gitpod/.cargo/bin:/home/gitpod/.foundry/bin:/root/.cargo/bin:$PATH"
