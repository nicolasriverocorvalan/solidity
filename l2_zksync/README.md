# zkSync

zkSync's native implementation of Account Abstraction presents several key distinctions and benefits when compared to Ethereum's ERC-4337 standard:

1. No Alternative Mempool: Transactions intended for account abstraction contracts are sent directly to the standard zkSync mempool. This eliminates the need for a separate mempool (alt-mempool) that ERC-4337 relies on.

2. No Central `EntryPoint.sol` Contract: In zkSync, transactions are routed directly to your specific account contract. This removes the `EntryPoint.sol` contract, which acts as a central coordinator in the ERC-4337 architecture, thereby simplifying the transaction flow.

3. Simplified Transaction Flow:
   * A user, interacting via a wallet like Metamask, signs a transaction (specifically, a `TxType: 113` transaction).
   * This signed message is broadcast to the zkSync network.
   * The network processes this message, which ultimately results in calling functions on "Your Account" – your custom smart contract.
   * "Your Account" can then initiate interactions with other decentralized applications (DApps, e.g., Dapp.sol).
   * Optional components, such as Signature Aggregators and Paymasters, can still be integrated into this flow.

4. Gasless Transactions from the User's Initial Perspective:
   * When a user initiates an action, such as deploying a contract using Remix on zkSync, they are presented with a "Signature request" for a `TxType: 113` transaction, rather than a standard transaction confirmation prompt that requests immediate gas payment.
   * The user signs this data, but they do not pay gas at this specific moment.
   * The signed data is transmitted to a `zkSync Era` node.
   * A node, or a relayer/bundler, then executes the transaction (e.g., deploys the contract).
   * Gas fees are paid during this execution step. However, these fees can be covered by a paymaster or deducted from the user's account by the system after the transaction is processed. This abstracts the immediate gas payment away from the user for certain operations, enhancing the user experience.

## The Paradigm Shift: All Accounts are Smart Contracts on zkSync

A fundamental design principle of zkSync Era is that all accounts are, at their core, smart contracts. This contrasts significantly with Ethereum's model.

1. Ethereum's Account Model: Ethereum distinguishes between two primary account types:
    * Externally Owned Account (EOA): Controlled by a private key (e.g., accounts managed by Metamask).
    * Smart Contract Wallet/Account: Programmable accounts represented by code deployed on the blockchain (e.g., Gnosis Safe, Argent).

This dichotomy can introduce complexities in development, such as needing to check msg.sender == tx.origin or determine if a caller is a contract.

2. zkSync Era's Unified Account Model: On zkSync Era, every account, including those that appear and behave like traditional EOAs (such as your Metamask account when used on the zkSync network), is an instance of a smart contract.
   * When an EOA interacts with zkSync, it is typically represented by a `DefaultAccount.sol` smart contract deployed on its behalf.
   * This unification simplifies interactions and development patterns, effectively allowing EOA-like addresses to possess smart contract capabilities.
   * The zkSync Block Explorer (e.g., `sepolia.explorer.zksync.io`) is designed to recognize these `DefaultAccount` instances. For a cleaner user experience, it often displays them as if they were simple EOAs (e.g., without a "Contract" tab), even though they are smart contracts under the hood.

## Key System Contract Interfaces and Implementations for Account Abstraction

1. `IAccount.sol` Interface:
    * Location in foundry-era-contracts: `lib/foundry-era-contracts/src/system-contracts/contracts/interfaces/IAccount.sol`
    * This interface is paramount. All account contracts on zkSync, including the `DefaultAccount` for EOAs and any custom account abstraction contracts you build, `must implement IAccount.sol`.
    * Key functions defined in this interface include:
        - `validateTransaction(bytes32 _txHash, bytes32 _suggestedSignedHash, Transaction calldata _transaction) external payable returns (bytes4 magic);`
        - `executeTransaction(bytes32 _txHash, bytes32 _suggestedSignedHash, Transaction calldata _transaction) external payable;`
        - `executeTransactionFromOutside(Transaction calldata _transaction) external payable;`. This function caters to specific use cases or legacy zkSync functionalities beyond the primary AA flow focused on validate and execute.
        - `payForTransaction(bytes32 _txHash, bytes32 _suggestedSignedHash, Transaction calldata _transaction) external payable;`
        - `prepareForPaymaster(bytes32 _txHash, bytes32 _suggestedSignedHash, Transaction calldata _transaction) external payable;`

2. `DefaultAccount.sol` Implementation:
   * Location in foundry-era-contracts: `lib/foundry-era-contracts/src/system-contracts/contracts/DefaultAccount.sol`
   * This contract provides the default smart contract implementation for accounts that function like EOAs on zkSync. When you use your Metamask wallet on zkSync, its address on the zkSync network corresponds to an instance of this `DefaultAccount` contract.

3. `Transaction` Struct:
   * The Transaction struct is a critical data structure passed as a parameter to many functions within the IAccount interface.
   * Imported from: It is defined and can be imported, for example, `from lib/foundry-era-contracts/src/system-contracts/contracts/interfaces/Transaction.sol` or accessible via utility libraries like `MemoryTransactionHelper.sol` within the foundry-era-contracts repository.
