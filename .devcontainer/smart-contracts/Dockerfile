# Builder stage
FROM mcr.microsoft.com/devcontainers/rust:1-bullseye AS builder
WORKDIR /

# Polkadot-SDK version to build binaries from. TODO! always grab latest by default
ARG SDK_BRANCH=polkadot-stable2503-6

# Setup environment for building Polkadot SDK binaries
RUN apt-get update && apt install --assume-yes git clang curl libssl-dev protobuf-compiler
RUN rustup update stable && \
    rustup default stable && \
    rustup target add wasm32-unknown-unknown && \
    rustup component add rust-src
RUN git clone -q --depth 1 -b $SDK_BRANCH https://github.com/paritytech/polkadot-sdk.git
WORKDIR /polkadot-sdk

# Build subkey binary
RUN rustup toolchain install nightly --component rust-src && \
    cargo +nightly build --release --package subkey

# Final image
FROM mcr.microsoft.com/devcontainers/base:bullseye

# User project mounts here
WORKDIR /project

# Install Node.js 22 and required tools
RUN apt-get update && \
    apt-get install -y curl wget git && \
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Foundry and Polkadot tools
RUN curl -L https://raw.githubusercontent.com/paritytech/foundry-polkadot/refs/heads/master/foundryup/install | bash && \
    /root/.foundry/bin/foundryup-polkadot

# Copy subkey binary from builder stage
COPY --from=builder /polkadot-sdk/target/release/subkey         /usr/local/bin/subkey

# Copy devtool scripts for container initialization and management
COPY ./scripts/devtool-scripts /usr/local/bin/devtool-scripts
COPY ./scripts/devtools.sh /usr/local/bin/devtools
RUN chmod +x /usr/local/bin/devtools /usr/local/bin/devtool-scripts/*

# Expose default Hardhat port (if running a local node)
EXPOSE 8545
