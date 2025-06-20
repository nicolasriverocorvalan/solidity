# Solidity Cheat Sheet

## Transactions fields
* nonce: tx count for the account.
* gas price: price per unit of gas (in wei).
* gas limit: max gas that the tx can use.
* to: address that the tx is sent to.
* value: amount of wei to send.
* data: what to send to the TO address.
* v, r, s: components of tx signature.

## Transactions - contract deployment
* nonce: tx count for the account.
* gas price: price per unit of gas (in wei).
* gas limit: max gas that the tx can use.
* to: empty.
* value: amount of wei to send.
* data: contract init code and contract bytecode.
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

* 'Receive/Fallback' special functions: The `receive` function is specifically designed to handle Ether transfers without data and is automatically invoked when Ether is sent to the contract in a transaction with no call data (msg.data is empty). The `fallback` function is used for handling calls with data or when the `receive` function is not defined. The `fallback` function can also handle Ether transfers with data. 
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

## EVM Transaction Types

| Type Identifier | Common Name | Defining EIP | Key Features |
| :--- | :--- | :--- | :--- |
| **`0x0`** | Legacy Transaction | (Pre-EIP-2718) | The original format. Uses a single `gasPrice` field. |
| **`0x1`** | Access List Transaction | EIP-2930 | Adds an `accessList` to specify addresses and storage keys the transaction will access, potentially reducing gas costs for complex interactions. Still uses `gasPrice`. |
| **`0x2`** | EIP-1559 Transaction | EIP-1559 | The modern standard. Replaces `gasPrice` with `maxPriorityFeePerGas` (the tip) and `maxFeePerGas`. The `baseFee` is burned. Also supports `accessList`. |
| **`0x3`** | Blob Transaction | EIP-4844 | Introduced for Layer 2 rollups (Proto-Danksharding). Adds fields for handling "blobs" of data (`maxFeePerDataGas`, `blobVersionedHashes`) to drastically reduce data-posting costs for L2s. |

## Transaction status

1. `Pending`: This is the initial state after you submit a transaction. It has been successfully broadcast to the network and is waiting in the "mempool" (a memory pool of pending transactions) to be picked up by a validator.

2. `Mined (or Confirmed)`: A validator has included your transaction in a new block, and that block has been successfully added to the blockchain. At this point, the transaction is permanent.
A mined transaction also has a sub-status: either Success or Failed (Reverted). A failed transaction was still included in a block and you still paid the gas fee, but the contract's code execution failed (e.g., a require statement was not met).

3. `Replaced / Dropped`: This is the other major possibility. This status means your transaction was removed from the mempool without being mined. This typically happens for two reasons:
   
    * `Replaced`: You (or your wallet software) submitted a new transaction with the exact same nonce but a higher gas fee. The network recognizes this as an intentional replacement, discards your original, slower transaction from the mempool, and prioritizes the new, more expensive one. This is a common way to "speed up" or "cancel" a stuck transaction.

    * `Dropped`: If your transaction's gas fee is too low to ever be picked up during a period of high network congestion, network nodes may eventually "drop" it from their individual mempools to make space for new, higher-fee transactions. If your transaction is dropped from enough nodes, it effectively disappears from the network without ever being mined or replaced.

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
