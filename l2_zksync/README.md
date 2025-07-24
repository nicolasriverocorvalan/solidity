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

## Compiling for zkSync and Navigating Warnings

To compile the contract for the zkSync Era environment, use the command: `forge build --zksync`

You will likely encounter numerous compilation warnings. These are generally expected due to the differences between the zkEVM (used by zkSync Era) and the standard EVM. They do not share identical opcodes. Foundry cheat codes and common Ethereum libraries (like OpenZeppelin or Solmate) often use EVM-specific opcodes (e.g., `extcodesize`, `ecrecover`). These trigger warnings when compiled for zkSync because zkSync has native account abstraction, making `ecrecover` within the account contract less conventional, as accounts can support diverse signature schemes.

## The Challenge and Solution: System Contract Calls & zkSync Simulations

Directly calling zkSync system contracts from other contracts can be complex and is often restricted for security reasons. zkSync addresses this with a mechanism called `simulations`. These are specially crafted call patterns within your Solidity code that the zkSync compiler recognizes and transforms, but only when a specific compiler flag is active.

When this flag is enabled, the compiler converts these simulation calls into the actual, low-level system contract calls required to interact with contracts like `NonceHolder`. If the flag is disabled, the simulation call remains as written, likely failing or behaving unexpectedly. Simulations thus serve as a developer-friendly abstraction layer, enabling privileged system contract interactions that are resolved at compile time.

### Activating Simulations: The `--system-mode` Compiler Flag

To enable the zkSync compiler to process these simulations, you must use the `--system-mode=true` flag with your compilation command.

```bash
forge build --zksync --system-mode=true
```

This flag instructs the zkSync compiler to recognize and transform simulation patterns into legitimate system calls.

### How zkSync Simulations Function: An Illustrative Example

The core idea behind simulations is a specific syntax that the compiler, in `system mode`, interprets specially. Consider this conceptual example (inspired by discussions on platforms like Ethereum Stack Exchange):

```solidity
// Conceptual example of a simulation pattern
// This is NOT actual production code for NonceHolder
bool success = call(address(SYSTEM_CONTRACT_PLACEHOLDER), gasleft(), abi.encodeWithSelector(SOME_SELECTOR, some_argument)) == SystemContract.someFunction(expected_return_value);
```

* `Without --system-mode=true`: The compiler would treat this as a standard external call, comparing its boolean return value to the result of `SystemContract.someFunction(expected_return_value)`.
* `With --system-mode=true`: The compiler recognizes this pattern. Instead of executing the call and the comparison, it replaces the entire line with the bytecode equivalent of making the intended system call, for example, `systemcontract.updateNonceHolder(1)` (if that were the target).

The `call(...) == SystemContract...` syntax is effectively syntactic sugar. It's a pattern developers write, which the compiler, when in system mode, translates into the appropriate low-level system interaction.

## Implementing Nonce Incrementation via Simulations

To implement the nonce increment, we'll leverage utilities provided by the `foundry-era-contracts` library, avoiding the need to write raw simulation patterns.

1. Import `SystemContractsCaller`: This library provides a helper function for making system calls.

```solidity
import {SystemContractsCaller} from "lib/foundry-era-contracts/src/system-contracts/contracts/libraries/SystemContractsCaller.sol";
```

2. Import `NONCE_HOLDER_SYSTEM_CONTRACT` Address: The address of the `NonceHolder` system contract is required. This is available in `Constants.sol`.

```solidity
import {NONCE_HOLDER_SYSTEM_CONTRACT} from "lib/foundry-era-contracts/src/system-contracts/contracts/Constants.sol";
```

Note: While these addresses are generally stable for mainnet, they can change with network upgrades. The values in Constants.sol typically reflect the current mainnet deployment.

3. Import `INonceHolder` Interface: To correctly ABI-encode the call data for our interaction with `NonceHolder`.

```solidity
import {INonceHolder} from "lib/foundry-era-contracts/src/system-contracts/contracts/interfaces/INonceHolder.sol";
```

4. Implement the Call in `validateTransaction`: Within your validateTransaction function, after other checks but before returning the magic value, you will increment the nonce.

```solidity
// Inside validateTransaction, after owner and fund checks
// _transaction is the IAccount.Transaction struct passed to validateTransaction
​
// This is the simulation: it gets replaced by a system call at compile time
// when --system-mode=true is used.
SystemContractsCaller.systemCallWithPropagatedRevert(
    uint32(gasleft()), // gasLimit: Pass remaining gas for the system call
    address(NONCE_HOLDER_SYSTEM_CONTRACT), // to: The NonceHolder system contract address
    0, // value: No ETH value is sent for this particular system call
    abi.encodeCall(INonceHolder.incrementMinNonceIfEquals, (_transaction.nonce)) // data: Encoded call to NonceHolder.incrementMinNonceIfEquals with the expected current nonce
);
```

Let's break down the systemCallWithPropagatedRevert parameters:

- `uint32(gasleft())`: Specifies the gas limit for the system call, using the remaining gas.
- `address(NONCE_HOLDER_SYSTEM_CONTRACT)`: The target system contract address.
- `0`: The Ether value sent with the call (zero in this case).
- `abi.encodeCall(INonceHolder.incrementMinNonceIfEquals, (_transaction.nonce))`: This is crucial. It ABI-encodes the call to the `incrementMinNonceIfEquals` function of the `INonceHolder` interface, passing the transaction's expected current nonce (`_transaction.nonce`) as the argument. This encoded data forms the payload for the system call.
