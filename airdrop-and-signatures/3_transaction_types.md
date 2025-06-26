# Transaction types on Ethereum

### Type 0

`Type 0` transactions were the first standard Ethereum transactions. It was the first standard Ethereum transaction before the introduction of newer types, specified when using the `--legacy` flag.

`Type 0` transactions include basic fields such as the sender and receiver addresses, the amount of Ether being transferred, and optional data for invoking smart contracts.

### Type 1 (0x01)

The new type was introduced to help developers and users adapt to the changes brought by `EIP-2929` and `EIP-2930`, ensuring that contracts continue to function correctly despite the new gas cost rules and the introduction of access lists.

* `EIP-2929` increased the gas costs for certain operations, particularly those related to accessing storage and account data. This change was made to improve the network's security and efficiency by making it more expensive to perform operations that could potentially be exploited.

* `IP-2930` introduced access lists, which are a way to specify which storage slots and accounts a transaction will access. By providing this information upfront, the Ethereum network can optimize gas costs and improve transaction efficiency. Access lists help mitigate the increased gas costs introduced by `EIP-2929` by allowing transactions to declare their intent, thus enabling more predictable and optimized gas usage.

By incorporating access lists directly into the transaction format, `type 1` transactions ensure that smart contracts and other on-chain operations continue to function correctly despite the new gas cost rules. This transition was crucial for maintaining the stability and usability of the Ethereum network as it evolved to meet new challenges and improve overall performance.

### Type 2 (0x02)

Type 2 transactions were introduced by `EIP-1559` during the Ethereum `London` fork. This new transaction type was designed to address the issue of high network fees on the Ethereum blockchain, which had become a significant problem for users and developers.

***Key Features of `type 2` transactions:***
1. Base fee:
    * Traditional gas price parameter is replaced with a base fee.
    * Base fee is dynamically adjusted for each block based on network demand.
    * This adjustment mechanism aims to stabilize transaction fees and make them more predictable.

2. Max priority fee per gas:
    * This is an additional fee that the sender is willing to pay to prioritize their transaction.
    * It allows users to incentivize miners to include their transactions in a block more quickly.
    * The max priority fee is essentially a tip for the miners.

3. Max fee per gas:
    * This represents the total maximum fee the sender is willing to pay for the transaction.
    * It includes both the base fee and the max priority fee.
    * By setting a max fee, users can cap their transaction costs, providing more control over their spending.

***note:*** ZK Sync supports `type 2` transactions, `it does not utilize the max fee parameters`, as gas functions differently on ZK Sync.

### Type 3 (0x03)

Type 3 transactions, introduced by `EIP-4844`, provide an initial scaling solution for `rollups`. `Rollups` are a layer 2 scaling technique that aggregates multiple transactions into a single batch, reducing the load on the Ethereum mainnet and improving transaction throughput.

One of the key features of `type 3` transactions is the `Max Blob Fee per Gas` parameter. This parameter sets the maximum fee the sender is willing to pay per gas unit specifically for `blob gas`. `Blob gas` is a specialized type of gas used in Ethereum to handle large data structures, particularly in the context of `rollups`. It is distinct from regular gas and has its own market, reflecting the unique requirements and costs associated with processing large data blobs.

Another important aspect of `type 3` transactions is the `Blob Versioned Hashes`. This is a list of versioned blob hashes associated with the transaction blobs. These hashes are crucial for verifying the integrity of the `blobs` and ensuring they are correctly linked to the transaction. By using versioned hashes, the Ethereum network can maintain the consistency and reliability of data within `rollups`.

A notable characteristic of `type 3` transactions is that the blob fee is deducted and burned from the sender's account before the transaction executes. This means that if the transaction fails, the blob fee is not refunded. This mechanism ensures that the costs associated with processing large data structures are covered, regardless of the transaction's outcome.

### Transaction types specific to ***ZK Sync***:

ZK Sync, a layer 2 scaling solution for Ethereum, introduces specific transaction types to enhance its functionality and efficiency. These transaction types are designed to leverage the unique features of ZK Sync, such as zero-knowledge proofs and account abstraction.

#### Type 113 (0x71)

`Type 113` transactions are defined by `EIP-712`, which standardizes data hashing and signing. This standardization enables advanced features like `account abstraction` and `paymasters`. Account abstraction allows for more flexible account management, while paymasters are smart contracts that can pay for transactions on behalf of users. Smart contracts on ZK Sync must be deployed using type 113 transactions.

Type 113 transactions include several fields specific to their operation:

- `Gas per pub data`: this field specifies the maximum gas the sender is willing to pay for a single byte of pub data. Pub data refers to the layer 2 (L2) state data that is submitted to layer 1 (L1). This ensures that the costs associated with data submission are covered.
- `Custom signature`: this field is used when the signer's account is not an Externally Owned Account (EOA). It allows for custom signature schemes, which can be useful for various advanced use cases
- `Paymaster params`: these parameters are used to configure a custom paymaster. A paymaster is a smart contract that pays for the transaction, enabling more flexible and user-friendly transaction fee management.
- `Factory depths`: this field contains the bytecode of the deployed smart contract. It is essential for deploying new smart contracts on ZK Sync using type 113 transactions.

#### Type 5 (0xFF)

`Type 5` transactions, also known as `Priority Transactions`, allow users to send transactions directly from layer 1 (L1) to layer 2 (L2) in ZK Sync. These transactions are prioritized to ensure timely processing and execution, providing a seamless bridge between the two layers. This capability is crucial for maintaining the efficiency and responsiveness of the ZK Sync network, especially when dealing with high-priority or time-sensitive transactions.
