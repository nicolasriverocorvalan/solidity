# Solidity Cheat Sheet

## Transactions fields
* nonce: tx count for the account.
* gas price: price per unit of gas (in wei).
* gas limit: max gas that the tx can use.
* to: address that the tx is sent to.
* value: amount of wei to send.
* data: what to send to the TO address.
* v, r, s: components of tx signature.

## GAS - Ethereum Improvement Proposals (EIP) 1559

* Transaction Fee: Amount paid to the block producer for processing the transaction.
  - Gas used * Gas Price (Gwie)

* Gas Price: Cost per unit of gas specified for the transaction, in Ether and Gwei. The higher the gas price the higher chance of getting included in a block.
  - Base fee: the minimum *gas price* you need to set to include your transaction. Ends up getting burnt.
  - Max fee: refers to the maximum gas fee that we are willing to pay for the transaction.
  - Max priority fee: the max gas fee that we are willing to pay plus the max tip that we are willing to give to validators.
* Transaction fee - burnt fee = how much money went to validators.

## Notes
* https://eth-converter.com/
* https://www.evm.codes/
* 1e18 = 1 ETH = 1 * 10 ** 18.
* 'Receive/Fallback' special functions:
```
    // Explainer from: https://solidity-by-example.org/fallback/
    // Ether is sent to contract
    //      is msg.data empty?
    //          /   \ 
    //         yes  no
    //         /     \
    //    receive()?  fallback() 
    //     /   \ 
    //   yes   no
    //  /        \
    //receive()  fallback()
```
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

## Ethereum Request for Comments (ERC)

### ERC-20

* ERC-20 Token Standard: It´s an smart contract that represent a token.
* Governance tokens.
* Secure an underlying network.
* Create a synthetic asset.
* +

### ERC-721 (NFT - Non-Fungible Token)

* Token URI.
* Metadata: an endpoint return the metadata.

### IPFS

* Decentralized storage (nodes optionally choose what to pin)
* our code -> hash it

## Testnet faucets

* [Google](https://cloud.google.com/application/web3/faucet/ethereum/sepolia)
* [Chainlink](https://faucets.chain.link/)
