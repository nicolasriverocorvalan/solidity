# Account Abstraction (AA)

* [EIP-4337 Account Abstraction Using Alt Mempool](https://eips.ethereum.org/EIPS/eip-4337)
* Deploy a smart contract that defines "what" can sign a transaction.
* `Ethereum` implements account abstraction using a smart contract called [EntryPoint.sol](https://github.com/eth-infinitism/account-abstraction/blob/develop/contracts/core/EntryPoint.sol). This contract acts as a gateway for handling user operations and transactions in a more flexible manner.
* [EIP-4337 entrypoint definition](https://eips.ethereum.org/EIPS/eip-4337#entrypoint-definition)
* `zkSync` has account abstraction natively integrated into its codebase. This allows for seamless handling of transactions and operations without the need for additional contracts.

## Simplifying Transaction Signing

* `Traditional approach`: Users sign transactions using private keys, which is secure but user-unfriendly. Losing or compromising a private key can result in loss of access or funds. Transactions are validated using the sender's private key, limiting transaction initiation to the account owner.

* `Account Abstraction solution`: AA allows transactions to be signed without traditional private keys. Instead, more user-friendly and secure alternatives can be used, such as phones, Google accounts, or biometrics. This flexibility enhances security and user experience by reducing the risk associated with private key management. Introduces more flexible validation options, allowing transactions to be validated in different ways, including having others pay for the gas fees. This opens up new possibilities for transaction management and execution.

## Ethereum transaction flow

1. `Off-Chain initiation`: `User operations`, such as transactions or smart contract interactions, start off-chain. This means they are processed outside the Ethereum blockchain. The purpose is to reduce the load on the network and speed up the initial handling and validation of these operations.

2. `Signing and sending to alt-mempool`: The user signs their operation, creating a user operation. This signed operation is then sent to an `alt-mempool`, not directly to the main Ethereum network. The `alt-mempool` is a collection of nodes designed to facilitate this off-chain to on-chain process. These nodes act as intermediaries, preparing the operation for entry into the Ethereum blockchain.

3. `Validation`: Before being sent on-chain, the user operation undergoes validation. This could involve checking the operation's integrity, the user's signature, and ensuring it conforms to certain rules or requirements.

4. `On-Chain transaction`: Once the operation is validated, it is sent on-chain as a transaction. This means it is submitted to the Ethereum blockchain to be executed as any other transaction would be.

5. `Gas fees and execution`: The `alt-mempool` nodes handle the execution of these transactions on behalf of the user. They pay the gas fees required for the transaction directly from the user's account. This process is managed by a smart contract called `EntryPoint.sol`, which coordinates the payment of gas fees and the execution of the transaction.

6. `User's smart contract as wallet`: At this stage, the user's smart contract acts as their wallet. It's where their assets or tokens are managed and from where gas fees are deducted. If a paymaster (a mechanism to handle gas payments) is not set up, the gas fees are directly deducted from the user's account associated with this smart contract.

7. `Deployment`: Finally, the smart contract, through which this entire process is managed, is deployed to the Ethereum blockchain. This means it becomes a part of the blockchain and can interact with other contracts and transactions according to its programming.

## zkSync's native integration (TxType 113)

zkSync integrates AA directly into its codebase, enabling seamless transaction handling without additional contracts.

## EIP-191

`EIP-191` aims to standardize how data is signed, making it easier for applications to verify signatures without needing to implement custom signing and verification mechanisms. This standard is crucial for applications that require secure, verifiable signatures for operations beyond simple cryptocurrency transactions, such as proving ownership, authenticating users, or executing off-chain agreements.

`EIP-191` is utilized in a wide range of applications within the Ethereum ecosystem:

1. `Authentication`: users can sign a piece of data to prove ownership of an Ethereum address, useful for login systems in decentralized applications (dApps).
2. `Off-chain agreements`: parties can sign agreements off-chain, saving transaction costs and only using the blockchain for dispute resolution or final settlement.
3. `Meta-transactions`: users can sign transactions that are executed by another party, who pays for the gas fees. This is particularly useful for improving user experience in dApps by removing the need for users to hold ETH for transaction fees.


## Debugging cheat sheet

* `forge test --debug testEntryPointCanExecuteCommands -vvv`
* `shift+G`: jump to the error.
* `k`: previous op.

