## Building the project

After any changes to the contract, run:

```bash
yarn build
```

to compile your contracts. This will also detect the [Contracts Extensions Docs](https://portal.thirdweb.com/thirdweb-deploy/contract-extensions) detected on your contract.

## Deploying Contracts

To deploy contracts, run the below command:

```bash
yarn deploy
```
The sequence of deployment is as follows:
1. Deploy the base contract
2. Deploy the implementation contract
3. Run `forge test --match-contract Initialize -vv `to get the contract call data. Ensure to update teh owner address to your address.
4. Deploy the proxy contract with the implementation contract address and the call data from the previous step.

## Releasing Contracts

To release a version of the contracts publicly:

```bash
yarn release
```
