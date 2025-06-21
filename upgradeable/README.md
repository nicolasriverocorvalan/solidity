# Upgradeable smart contracts

## Methods

### Parameterize

* Can't add new storage or logic
* Simple but not flexible
* Who the admins are?

### Social Migration

* By social convention you tell everybody "this is the new contract"
* Truest to blockchain values
* Easiest to audit
* Lot of work to convince user to move
* Different addresses

### Proxies

* Use delegate call functionality, where te code int the target contract is executed in the context of the calling contract. Think of delegate call as a call option that allows one contract to borrow a function from another contract.
* `msg.sender` and `msg.value` do not change their values.
* The `implementation` contract: which has all our code of our protocol. When we upgrade, we launch a brand new implementation contract.
* The `proxy` contract: which points to which implementation is the "correct" one, and routes everyone's function calls to that contract.
* The `user` make calls to the proxy.
* The `admin` is the user or group of users/voters who upgrade to new implementation contracts.
* All the `storage variables` are going to be stored in the proxy contract and not in the implementation contract.

#### Storage clashes
In the context of upgradeable smart contracts, proxies are a fundamental pattern. The core idea is to separate the logic of your contract from its data.

* `Proxy Contract (A)`: This contract holds the state (data) and has a fixed address. It contains a fallback function that delegates all calls to an implementation contract.
* `Implementation Contract (B)`: This contract holds the business logic. When you want to upgrade your contract, you deploy a new implementation contract and update the proxy to point to this new address.

The proxy uses the `DELEGATECALL` opcode (in Solidity's `delegatecall` function). This is crucial:
* When `DELEGATECALL` is executed, the code of the called contract (Implementation B) is executed.
* Crucially, the context of the calling contract (Proxy A) is maintained. This means:
    * The `msg.sender` and `msg.value` are the original sender and value of the transaction to the proxy.
    * All state modifications (reading and writing storage variables) occur on the storage of the proxy contract (A), not the implementation contract (B).

* We do the logic of contract B inside contract A. So if contract B says we need to set value to 2, we go ahead and set value to 2. But we actually set the value of whatever is in the same storage location on contract A as contract B, so if we have two variables in contract A, we are going to set the first storage spot on contract A to the new value. We can only append new storage variables and new implementation contracts and we can't reorder or change old ones.

Imagine your proxy contract (A) has a state variable uint256 public owner; at storage slot 0. Your initial implementation contract (B1) has uint256 public counter; also at storage slot 0. If a function in B1 attempts to modify counter, it will actually modify owner in the proxy's storage. This is a storage clash.

#### Function selector clashes
* Function Selector: This is a 4-byte bytes4 hash derived from the Keccak-256 hash of a function's canonical signature (its name followed by its parameter types, without spaces). Example: For function `transfer(address to, uint256 amount)`, the signature is `transfer(address,uint256)`. The selector is the`first 4 bytes` of `keccak256("transfer(address,uint256)")`.

* It's is possible that the function in the implementation contract has the same function selector as an admin function in the proxy contract.

* Due to the nature of hashing (even though Keccak-256 is designed to minimize collisions), it's theoretically possible (though statistically unlikely for random hashes) that functionA also generates the exact same 4-byte functionB selector. Or, more commonly, a malicious or poorly designed implementation contract could intentionally include a function with a selector that clashes with an important proxy function.

* Example:a user intends to call `processPayment()` on a proxy contract:
    1. They send a transaction to the proxy with the data corresponding to selector `0xabcdef12`.
    2. The proxy receives the call.
    3. Instead of falling through to `DELEGATECALL` and executing `processPayment()` in the implementation, the proxy contract 
    4. Itself recognizes `0xabcdef12` as its own `adminWithdrawFunds()` function.
    5. The proxy directly executes `adminWithdrawFunds()` within the proxy's context.

## Proxy implementations

### 1. Transparent Proxy Pattern

* Include the upgrade and admin logic in the proxy itself.
* Admins can't call implementation contract functions.
* Users still powerless on admin functions.
* Admin functions are functions that govern the upgrades.

### 2. Universal Upgradeable Proxies. Universal Upgradeable Proxy Standard (UUPS)

* The upgrade is handled by the implementation, and can eventually be removed.
* `AdminOnly upgrade functions` are in the implementation contracts instead of the proxy.
* Gas saver.

### 3. Diamond proxy pattern

* Allows multiple implementation contracts.
* More granular upgrades.

## Standard Proxy Storage Slots (EIP-1967)

* `EIP-1967` is an Ethereum Improvement Proposal that standardizes how upgradeable proxy contracts store critical information.

## Notes

* https://solidity-by-example.org/delegatecall/
* `delegatecall` executes the target contract's code in the caller's context, modifying the caller's storage, while `call` executes in the target's context, modifying the target's storage.

* In many proxy patterns the `fallback` function is commonly used to forward calls with unrecognized function selectors from the proxy to the implementation contract.
