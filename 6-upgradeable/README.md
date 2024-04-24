# Upgradeable smart contracts

## Parameterize

* Can't add new storage or logic
* Simple but not flexible
* Who the admins are?

## Social Migration

* By social convention you tell everybody "this is the new contract"
* Truest to blockchain values
* Easiest to audit
* Lot of work to convince user to move
* Different addresses

## Proxies

* Use delegate call functionality, where te code int the target contract is executed in the context of the calling contract.
* msg.sender and msg.value do not change their values.
* The implementation contract: which has all our code of our protocol. When we upgrade, we launch a brand new implementation contract.
* The proxy contract: which points to which implementation is the "correct" one, and routes everyone's function calls to that contract.
* The user make calls to the proxy.
* The admin is the user or group of users/voters, who upgrade to new implementation contracts.
* All the storage variables are going to be stores in the proxy contract and not in the implementation contract.
* Storage Clashes:
  * We do the logic of contract B inside contract A. So if contract B says we need to set value to 2, we go ahead and set value to 2. But we actually set the value of whatever is in the same storage location on contract A as contract B.
* Function Selector Clashes:
  * Function selector: a 4 bytes hash of a function name and function signature that defines the function.
  * It's is possible that the function in the implementation contract hast the same function selector as an admin function in the proxy contract.

### Transparent Proxy Pattern

* Admins can't call implementation contract functions.
* Users still powerless on admin functions.
* Admin functions are functions that govern the upgrades.

### Universal Upgradeable Proxies

* AdminOnly Upgrade functions are in the implementation contracts instead of the proxy.
* Gas saver.

### Diamond pattern

* Allows multiple implementation contracts.
* More granular upgrades.

## Delegate Call vs Call Function

Similar to a call function, 'delegate call' is a fundamental feature of Ethereum. However, they work a bit differently. Think of delegate call as a call option that allows one contract to borrow a function from another contract.

## Notes

* EIP-1967: Standard Proxy Storage Slots. Standardize where proxies store the address of the logic contract they delegate to, as well as other proxy-specific information.
