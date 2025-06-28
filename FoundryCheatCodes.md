# Foundry Cheatcodes

### Foundry Cheatcodes Reference

| Category | Cheatcode / Utility | Description |
| :--- | :--- | :--- |
| **State & Environment** | `prank(address)` | Sets `msg.sender` for the **next single call**. |
| | `startPrank(address)` | Sets `msg.sender` for all subsequent calls until `stopPrank` is called. |
| | `stopPrank()` | Resets `msg.sender` back to the default test address. |
| | `deal(address, uint256)` | Sets the Ether balance of a specified address. |
| | `warp(uint256)` | Sets the `block.timestamp`. |
| | `roll(uint256)` | Sets the `block.number`. |
| | `fee(uint256)` | Sets the `block.basefee`. |
| | `store(address,bytes32,bytes32)` | Writes a value to a specific storage slot of a contract. |
| | `load(address,bytes32)` | Reads a value from a specific storage slot of a contract. |
| | `etch(address,bytes)` | Deploys bytecode to a specified address. |
| | `setNonce(address,uint64)` | Sets the nonce of a specific address. |
| | `getNonce(address)` | Gets the current nonce of a specific address. |
| **Broadcasting** | `broadcast()` | Makes the **next single call** a real transaction from the default sender. |
| | `broadcast(address)` | Makes the **next single call** a real transaction from a specified sender. |
| | `startBroadcast()` | Makes **all subsequent calls** real transactions from the default sender. |
| | `startBroadcast(address)` | Makes **all subsequent calls** real transactions from a specified sender. |
| | `stopBroadcast()` | Stops broadcasting, returning to simulation mode. |
| **Assertions & Events** | `expectRevert()` | Asserts that the next call will revert (can be overloaded with a reason/error). |
| | `expectEmit(...)` | Asserts that a specific event is emitted on the next call. |
| | `expectCall(...)` | Asserts that a specific address is called with specific calldata/value. |
| | `mockCall(...)` | Mocks the return data for a specific call to a contract. |
| | `clearMockedCalls()` | Clears all previously set mock calls. |
| **Fuzzer** | `assume(bool)` | Discards fuzzer runs that do not meet a specific condition. |
| | `label(address,string)` | Assigns a human-readable label to an address in call traces. |
| **Address Utilities** | `makeAddr(string memory label)` | A utility from `forge-std/Test.sol` that generates a fresh, deterministic address from a string label. |
| **Forking** | `createFork(string)` | Creates a new fork from an RPC URL and returns its ID. |
| | `createSelectFork(string)` | Creates and immediately selects a new fork. |
| | `selectFork(uint256)` | Selects a previously created fork to run tests against. |
| | `activeFork()` | Returns the ID of the currently active fork. |
| | `transact(uint256,bytes32)` | Replays a transaction from the forked chain into the test environment. |
| **Signing** | `rememberKey(uint256)` | Remembers a private key and returns its corresponding public address. |
| | `sign(uint256,bytes32)` | Signs a digest with a remembered private key. |
| | `addr(uint256)` | Computes the address for a given private key. |
| **Filesystem & Shell** | `readFile(string)` | Reads the content of a file from the local filesystem. |
| | `writeFile(string,string)` | Writes content to a specified file on the local filesystem. |
| | `ffi(string[])` | Executes an external command via the Foreign Function Interface (FFI). |
| | `envString(string)` | Reads an environment variable as a string (e.g., `envUint`, `envBool`). |
| | `parseJson(string)` | Parses a string of JSON data into Solidity types. |


* In stateful fuzz testing with Foundry, what is the primary purpose of using the `vm.bound` cheatcode on input parameters like `amount`?

    To constrain the input values within a specific, valid range for the function being tested.

    ```solidity
    function test_deposit_validAmount(uint256 amount) public {
    // Constrain the fuzzed 'amount' to be between 1 and 1,000,000 tokens.
    // This avoids testing with amount = 0 or a ridiculously large number.
    vm.bound(amount, 1 ether, 1_000_000 ether);

    // ... rest of the test logic for depositing 'amount' ...
    ```

* `vm.warp(uint256 newTimestamp)`
  - Purpose: This is the most direct and common cheatcode for testing time-dependent logic. It sets block.timestamp to the exact newTimestamp you provide.

    - Use Case: If you want to check the state of your contract at a specific point in the future (e.g., exactly one year from now to check annual interest), you would calculate that future timestamp and use vm.warp() to jump directly to it.

    ```solidity
    // Go to a specific time in the future
    uint256 oneYearFromNow = block.timestamp + 365 days;
    vm.warp(oneYearFromNow);

    // Now, any logic that reads `block.timestamp` will see `oneYearFromNow`.
    myContract.accrueInterest();
    ```

* `vm.expectRevert(bytes4 selector)`:

    - Purpose: This cheatcode asserts that the revert data is exactly the 4-byte selector and nothing else.
    - Use Case: It should be used when a function reverts with a custom error that has no arguments, like error `Unauthorized()`;. In this case, the entire revertdata is just the 4-byte selector.

* `vm.expectPartialRevert(bytes4 selector)`:

    - Purpose: This cheatcode asserts that the revert data begins with the specified 4-byte selector but ignores any data that follows.
    - Use Case: This is the correct tool for when a function reverts with a custom error that has arguments, like `AccessControlUnauthorizedAccount(address account, bytes32 role)`. It allows you to verify the correct error type was triggered without needing to match the specific account and role values.

* `vm.createFork(urlOrAlias)`: Creates a new fork environment in the background from the specified RPC URL (e.g., an Alchemy or Infura URL) or a named alias from your foundry.toml file. It returns a unique uint256 fork ID but `does not` switch the active execution context. Your test continues to run on the current chain until you explicitly switch using `vm.selectFork(forkId)`.

* `vm.makePersistent(address)`:In Foundry multi-fork testing scenarios, it ensures that the specified contract's address, code, and storage are preserved across different forks during test execution.

