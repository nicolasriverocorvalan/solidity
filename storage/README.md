## function visibility specifiers

* `public`: This is the most permissive specifier. A public function can be called from anywhere: internally from within the contract itself, externally from other contracts, and by users making transactions.
* `private`: This is the most restrictive. A private function can only be called from other functions within the same contract where it is defined. It cannot be called by derived contracts or externally.
* `external`: An external function can only be called from outside the contract (i.e., from other contracts or via transactions). It cannot be called internally (e.g., this.myExternalFunction()).
* `internal`: An internal function can be called from within the defining contract and also from any contracts that inherit from it. It cannot be called externally.

## Notes

* `Storage variables` are meant to persist between function calls and are only declared at the contract level. Can't be used for new variables inside a function in Solidity.
* In Solidity, all storage locations are initialized to a default value, which is the byte-representation of zero. This concept applies to mappings as well.

* The `view` keyword is a state mutability specifier in Solidity. It acts as a promise that the function will not alter the state of the blockchain.

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

* Blockchain Oracle: Any device that interacts with the off-chain world to provide external data or computation to smart contracts.

* Library: similar to contracts but you can't declare any state variable and you can't send ether. A library is embedded into the contract if all functions are `internal`. 
When you create a library where all of its functions are `internal`, the Solidity compiler acts like a "copy and paste" machine. It takes the library's bytecode and embeds it directly into the bytecode of every contract that uses it.
If a library has at least one `public` or `external` function, it must be deployed as a separate, standalone entity on the blockchain.
The most common and elegant way to use a library is with the `using MyLibrary for uint256` directive. This "attaches" the library's functions to a specific data type, making the code clean and object-oriented.

* Three different methods of sending ETH from one account to another: `transfer`, `send`, and `call`. `call` is CURRENT BEST PRACTICE for sending ETH from one contract to another, provided you use security precautions. Because it forwards all gas, it makes your contract vulnerable to re-entrancy attacks if not handled correctly. The standard security pattern is the Checks-Effects-Interactions Pattern combined with a re-entrancy guard.

* `Constant` variables are initialized at compile time, while `immutable` variables are initialized at deployment time.
