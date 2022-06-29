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


# DCA architecture

## Sequence diagram
<img src="./static/chainlink keeper SeqDiag.png" width="100%">

### Legends
- **CL registery owner**: Chainlink keeper registery owner (can approve new cron registration)
- **Final user**: DCA customer
- **Nested DCA**: Nested DCA factory contract
- **CL cron factory**: Chainlink Cron factory contract (only used to deploy cron contract)
- **Link token**: Chainlink link token (ERC677)
- **CL keeper registrar**: Chainlink keepers registrar (used to request a new cron contract registration into Chainlink nodes network)  
- **CL keeper registry**: Chainlink keeper registry
- **Deployed cron contract**: A cron contract deployed by the CL cron factory (only used to call another contract when the cron is ran)
- **Target contract**: The final target contract that is called at each cron run.
