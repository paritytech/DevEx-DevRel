FROM --platform=linux/amd64 rust:1.88-slim

# Ensure /workspace exists before any commands reference it
RUN mkdir -p /workspace

# Install base dependencies
RUN apt-get update && apt-get install -y \
    curl ca-certificates unzip help2man git \
    && curl -sSL https://just.systems/install.sh | bash -s -- --to /usr/local/bin \
    && rm -rf /var/lib/apt/lists/*

# Install foundryup-polkadot and prebuilt binaries
RUN curl -L https://raw.githubusercontent.com/paritytech/foundry-polkadot/refs/heads/master/foundryup/install | bash && \
    /root/.foundry/bin/foundryup-polkadot

# Generate man pages
RUN mkdir -p /root/.foundry/man && \
    for bin in /root/.foundry/bin/*; do \
        help2man -N "$bin" > "/root/.foundry/man/$(basename $bin).1" || echo "Skipping $bin"; \
    done

ENV PATH="/root/.foundry/bin:$PATH"

# Download and install Polkadot-compatible Substrate node and ETH-RPC binaries
RUN curl -L http://releases.parity.io/substrate-node/polkadot-stable2555-rc5/x86_64-unknown-linux-gnu/substrate-node -o /usr/local/bin/substrate-node && \
    chmod +x /usr/local/bin/substrate-node && \
    curl -L http://releases.parity.io/eth-rpc/polkadot-stable2555-rc5/x86_64-unknown-linux-gnu/eth-rpc -o /usr/local/bin/eth-rpc && \
    chmod +x /usr/local/bin/eth-rpc

ENV PATH="/tools:$PATH"