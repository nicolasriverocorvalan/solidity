# Goal
1. Get funds from users.
2. Withdraw funds.
3. Set a minimum funding in USD (5 USD).
4. Use Chainlink data feeds (https://data.chain.link).
5. Create a Library.
6. GAS optimization (vars: constant/immutable; replace 'require' for custom errors)

## Etherscan contract
https://sepolia.etherscan.io/address/0xc19de6c396cb7483c246f4f3863fcd216bf4d51e

## Notes
* HelperConfig
  - Deploy mocks when we are in a local Anvil chain.
    1. Deploy the mock contract.
    2. Return the mock address.
  - Keep track of contract address across different chains.

## Cheat sheet
* https://github.com/smartcontractkit/chainlink-brownie-contracts
* forge install smartcontractkit/chainlink-brownie-contracts@0.8.0 --no-commit
* forge test -vv
* forge script script/DeployFundMe.s.sol
* forge test --match-test testPriceFeedVersionIsAccurate -vvv --rpc-url $SEPOLIA_RPC_URLx|
* forge coverage --rpc-url $SEPOLIA_RPC_URL
* forge snapshot --match-test testWithdrawFromMultipleFunders (gas-snapshot)
* Storage:
  - forge inspect FundMe storageLayout
  - cast storage [contract]
* forge install ChainAccelOrg/foundry-devops --no-commit
* make deploy ARGS="--network sepolia"
* cast sig "fund()" (get function selector)

## Testing
1. Unit
  - Testing an specific part of our code.
2. Integration
   - Testing how our code works with other parts of our code.
3. Forked
   - Testing our code on a simulated real env.
4. Staging
   - Testing our code in a real env that is not prod.

## Testing pattern
1. Arrange: setup the test.
2. Act: action we want to test.
3. Assert.

## Chisel

Allows us to write Solidity in our terminal and execute it line by line.
