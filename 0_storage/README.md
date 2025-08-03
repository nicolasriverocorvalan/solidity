## Function visibility specifiers

* `public`: This is the most permissive specifier. A public function can be called from anywhere: internally from within the contract itself, externally from other contracts, and by users making transactions.
* `private`: This is the most restrictive. A private function can only be called from other functions within the same contract where it is defined. It cannot be called by derived contracts or externally.
* `external`: An external function can only be called from outside the contract (i.e., from other contracts or via transactions). It cannot be called internally (e.g., this.myExternalFunction()).
* `internal`: An internal function can be called from within the defining contract and also from any contracts that inherit from it. It cannot be called externally.

## Notes

* `Storage variables` are meant to persist between function calls and are only declared at the contract level. Can't be used for new variables inside a function in Solidity.
* In Solidity, all storage locations are initialized to a default value, which is the byte-representation of zero. This concept applies to mappings as well.
* Each read operation from persistent storage consumes a substantial amount of gas.
* The storage area is not a single contiguous block of memory but is organized into numbered "slots," each capable of holding 32 bytes (256 bits) of data. Here's how the allocation works:
  1. Sequential Order: The compiler processes the state variables declared in your contract from top to bottom.
  2. Slot Allocation: The first variable declared is assigned to slot 0, the second to slot 1, the third to slot 2, and so on.
  3. Packing Small Variables: To optimize storage usage and reduce gas costs, Solidity attempts to "pack" multiple smaller variables (any type smaller than 32 bytes, like uint128, uint16, bool, address) into a single 32-byte slot if they are declared sequentially. The packing starts from the right side of the slot (lower-order bytes).

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

* `Modifiers` allow reusable code to be applied to functions, reducing code duplication and improving readability.

* Solidity provides a global variable, `block.chainid`, which returns the unique ID of the blockchain the code is currently executing on.

* The `Arrange-Act-Assert (AAA)` pattern is a widely adopted structure for writing clear, simple, and maintainable tests. It breaks down each test function into three distinct, logical parts.

1. `Arrange`: This is the setup phase. You prepare all the necessary preconditions for your test. This includes:
   * Deploying contracts.
   * Setting up initial variables and state (e.g., using vm.deal to give a user an ETH balance).
   * Creating test users and addresses (e.g., using makeAddr).

2. `Act`: This is the execution phase, and it should ideally be a single line of code. You invoke the specific function or trigger the precise behavior that you want to test. This is the "action" you are verifying.

3. `Assert`: This is the verification phase. After the "Act" has occurred, you check to see if the outcome is what you expected. This involves making one or more assertions, such as:
    * Checking if a state variable was updated correctly (assertEq).
    * Verifying that an event was emitted (vm.expectEmit).
    * Ensuring a balance changed as expected.

* `Chisel` is a key part of the Foundry tool suite that provides an interactive Solidity REPL (Read-Eval-Print Loop). It allows developers to quickly write and test small pieces of Solidity code directly in their terminal without needing to create a full project, contract, or test file

* Two different types of bytecode that are generated during the compilation and deployment process.
  1. `Initial Bytecode (or Creation Bytecode)`: This is the code that is actually sent in the data field of the deployment transaction. It contains two parts:

     - The contract's constructor logic and the code needed to initialize state variables.
     - The Deployed Bytecode itself.

        This Initial Bytecode is executed only once during the deployment transaction. Its job is to set up the contract's initial state and then return a copy of the Deployed Bytecode. After this one-time execution, the Initial Bytecode is discarded.

  2. `Deployed Bytecode (or Runtime Bytecode)`: This is the code that is returned by the Initial Bytecode. This is the actual code that gets permanently stored at the new smart contract's address on the blockchain. It contains all the function logic (the dispatcher, function bodies, etc.) needed to handle future calls to the contract, but it does not contain the constructor logic.

* `Application Binary Interface (ABI)`: when a smart contract is compiled, a standard interface specification is generated to define how applications can interact with it.

* `bytecode`: The low-level instructions executed by the blockchain's virtual machine.

* The `Arrange-Act-Assert (AAA)` pattern is a simple, three-step structure for writing clean, focused, and easily understandable tests.
    1. `Arrange`: Set up the scene. Prepare all the necessary preconditions for your test, such as deploying contracts, creating users, and setting initial balances.
    2. `Act`: Perform the single action. Execute the one specific function or behavior that you are testing.
    3. `Assert`: Verify the outcome. Check that the action produced the expected result by comparing the final state of the contract against your expectations.

* `calldata` contain the function selector (first 4 Bytes) followed by the ABI-encoded arguments for that function.

* The `Checks-Effects-Interactions (CEI)` pattern is a widely recognized best practice primarily designed to mitigate `reentrancy` attacks.
    1. Checks: first, validate all conditions
    2. Effects: second, update all internal state variables.
    3. Interactions: finally, interact with any external contracts or addresses.
