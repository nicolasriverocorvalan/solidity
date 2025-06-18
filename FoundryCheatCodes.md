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
