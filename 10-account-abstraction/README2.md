# Account abstraction - EIP-4337

* Define a smart contract that defines "what" can sign a transaction.
* `Ethereum` implements account abstraction using a smart contract called [EntryPoint.sol](https://github.com/eth-infinitism/account-abstraction/blob/develop/contracts/core/EntryPoint.sol). This contract acts as a gateway for handling user operations and transactions in a more flexible manner.
* `zkSync` has account abstraction natively integrated into its codebase. This allows for seamless handling of transactions and operations without the need for additional contracts.
* User Operations (Off-Chain)

## Ethereum transactions

User operations are sent off-chain, this means that the initial handling and validation occur outside the main blockchain network, reducing congestion and improving efficiency. The user operation is signed (with Google for example) and is sent to the `alt-mempool`, which then sends it to the main blockchain network. The `alt-mempool` is any nodes which are facilitating this operation, so the user is not sending their transaction to the Ethereum nodes.


