# Provably Random Raffle Contracts

This code is to create a provably random smart contract lottery.

1. User can enter by paying for a ticket.
   1. The tickets fees are going to go to the winner during the draw.
2. After X period of time, the lottery will automatically draw a winner.
   1. And this will be done programmatically.
3. Using Chainlink.
   1. VRF (Verifiable Random Function) -> randomness.
   2. Automation -> time based trigger.

## Order of layout

### Layout of Contract
- version
- imports
- errors
- interfaces, libraries, contracts
- Type declarations
- State variables
- Events
- Modifiers
- Functions

### Layout of Functions:
- constructor
- receive function (if exists)
- fallback function (if exists)
- external
- public
- internal
- private
- view & pure functions

## Cheat sheet

* `forge install smartcontractkit/chainlink-brownie-contracts@0.6.1 --no-commit`
* `forge script script/Interactions.s.sol:FundSubscription --rpc-url $SEPOLIA_RPC_URL --private-key $SEPOLIA_PRIVATE_KEY --broadcast`
* `forge coverage --report debug > coverage.txt`
