## function visibility specifiers

* `public`: This is the most permissive specifier. A public function can be called from anywhere: internally from within the contract itself, externally from other contracts, and by users making transactions.
* `private`: This is the most restrictive. A private function can only be called from other functions within the same contract where it is defined. It cannot be called by derived contracts or externally.
* `external`: An external function can only be called from outside the contract (i.e., from other contracts or via transactions). It cannot be called internally (e.g., this.myExternalFunction()).
* `internal`: An internal function can be called from within the defining contract and also from any contracts that inherit from it. It cannot be called externally.

## Notes

* `Storage variables` are meant to persist between function calls and are only declared at the contract level. Can't be used for new variables inside a function in Solidity.
* In Solidity, all storage locations are initialized to a default value, which is the byte-representation of zero. This concept applies to mappings as well.
* The `view^ keyword is a state mutability specifier in Solidity. It acts as a promise that the function will not alter the state of the blockchain.
* Solidity can store data in different locations:
  1. Calldata
  2. Memory
  3. Storage
  4. Stack
  5. Code
  6. Logs
* In Solidity, `calldata` and `memory` are temporary storage locations for variables during function execution. `calldata` is read-only, used for function inputs that can't be modified. In contrast, `memory` allows for read-write access, letting variables be changed within the function. To modify `calldata` variables, they must first be loaded into `memory`.
* Most variable types default to `memory` automatically. However, for **strings**, you must specify either `memory` or `calldata` due to the way arrays are handled in memory.
* `view` and `pure` are special keywords used to declare how a function interacts with the blockchain's state.
* `view` functions can read from the blockchain state but cannot modify it.
* `pure` functions cannot even read from the blockchain state, let alone modify it. They operate completely independently, only using their input parameters and local variables.
* When you override a function from a parent contract:
    1. Parent function must be virtual: First, the function in the parent contract must be marked with the `virtual` keyword. This explicitly signals that the function is designed to be overridden by child contracts.
    2. Child function must use override: The function in the child contract must use the `override` keyword. This shows the explicit intention to replace the parent's function.
* `new` keyword is used specifically for one primary purpose: to create and deploy a new instance of a contract from within another contract.
* The `payable` keyword is a modifier that allows a function or an address to receive Ether directly into the smart contract.
* `revert `is a special action that stops execution, undoes all changes to the state, and returns the remaining gas to the caller.
