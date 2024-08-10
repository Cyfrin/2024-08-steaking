# Steaking

# Contest Details

### Prize Pool

- High - 100xp
- Medium - 20xp
- Low - 2xp

- Starts: TBD
- Ends: TBD

### Stats

- nSLOC: 177
- Complexity Score: 🤷

## About the Project

Steak is a yield farming protocol in its pre-launch phase. It boasts an attractive APY, various vault management strategies, and a strong and active community. Being in the pre-launch phase, Steak wants to bootstrap liquidity for its ERC4626 WETH vault and reward early adopters. For this, Steak has launched a points campaign where users can stake their ETH and earn points, which will allow users to be eligible for the $STEAK token airdrop in the future.

The staking period lasts for a total of 4 weeks where users can stake their raw ETH in the `Steaking` contract. The minimum amount that can be staked is `0.5` ether. 1 ETH staked gives the user 1000 points on the backend server. Users can unstake to adjust their staked ETH amount, or withdraw it completely.

After the 4 week staking period ends, the Steak protocol team will set the address of the freshly deployed ERC4626 WETH vault. Users will be able to convert their raw staked ETH into WETH, deposit into the WETH vault, and claim their shares.

## Actors

1. **Users**: Can stake and unstake raw ETH into the vault. After the staking period ends, users can convert ETH to WETH, and deposit it into the WETH vault.
2. **Steak protocol team multisig**: The multisig is the owner of the `Steaking` contract, and is responsible for setting the vault address after the staking period ends.

## Scope (contracts)

All the files listed below are in scope.

```
src
├── steaking-contracts
│   └── src
│       └── Steaking.vy
└── steaking-server
    └── src
        ├── models
        │   └── steakPoints.js
        ├── utils
        │   ├── connectToMongoDb.js
        │   ├── constants.js
        │   └── getConfig.js
        └── main.js
```

## Compatibilities

The `Steaking` contract is to be deployed on Ethereum mainnet only.

## Setup

Ensure that you have git, python3, pip3, venv, foundry, node.js, and pnpm installed and configured on your system.

### Setting up the contracts

Cd into the `steaking-contracts` folder, create a virtual environment with python3 venv, and activate it,

```bash
cd steaking-contracts

python3 -m venv .venv

source .venv/bin/activate
```

Then install all the requirements from `requirements.txt`,

```bash
pip3 install -r requirements.txt
```

Now, it's time to setup Foundry,

```bash
forge test
```

That's it! You should be good to go now.

### Setting up the server

This one is slightly easier. Cd into `steaking-server`,

```bash
cd steaking-server
```

Continue by filling in the values in `.env.example`, and renaming the file to `.env`. Then install the node modules,

```bash
pnpm install
```

## Known Issues

The protocol has not been audited before, and there are no currently known issues.
