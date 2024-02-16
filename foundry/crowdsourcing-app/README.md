## Cheat sheet
* https://github.com/smartcontractkit/chainlink-brownie-contracts
* forge install smartcontractkit/chainlink-brownie-contracts@0.8.0 --no-commit
* forge test -vv
* forge script script/DeployFundMe.s.sol
* forge test --match-test testPriceFeedVersionIsAccurate -vvv --rpc-url $SEPOLIA_RPC_URL
* forge coverage --rpc-url $SEPOLIA_RPC_URL 

## Testing
1. Unit
  - Testing an specific part of our code.
2. Integration
   - Testing how our code works with other parts of our code.
3. Forked
   - Testing our code on a simulated real env.
4. Staging
   - Testing our code in a real env that is not prod.
