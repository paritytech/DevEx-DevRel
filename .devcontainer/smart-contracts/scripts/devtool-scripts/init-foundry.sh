echo "setting up foundry!"

curl -L https://raw.githubusercontent.com/paritytech/foundry-polkadot/refs/heads/master/foundryup/install | bash
source /root/.bashrc
foundryup-polkadot

forge init --no-git --force
