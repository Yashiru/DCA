# R&D DCA
This repository is a Solidity project aiming to create a solution for the creation of 100% automatic [DCA](https://en.wikipedia.org/wiki/Dollar_cost_averaging) positions through the use of chainlink keepers.
The project is managed with [Foundry](https://book.getfoundry.sh/).

## Setup project 
Install dependencies
```bash
forge install https://github.com/smartcontractkit/chainlink.git
forge install https://github.com/OpenZeppelin/openzeppelin-contracts
```

## Run tests
### Without fork
```bash
forge test -vv
```

### With fork
```bash
forge test --fork-url <your_rpc_endpoint> -vv
```

## Deploy
``` bash
export ETHERSCAN_API_KEY=<your_etherscan_api_key> && \
forge create src/DcaFactory.sol:DcaFactory \
    --rpc-url <your_rpc_endpoint> \
    --private-key <your_private_key> \
    --constructor-args <chainlink_cron_up_keep_factory_address> <link_token_address> \
    --verify
```