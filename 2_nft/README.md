## Cheat sheet
* `forge install OpenZeppelin/openzeppelin-contracts --no-commit`
* `forge install Cyfrin/foundry-devops --no-commit`
* `make deploy ARGS="--network sepolia`
* `make mint ARGS="--network sepolia`
* `https://ipfs.io/ipfs/QmSsYRx3LpDAb1GZQm7zZ1AuHZjfbPkD6J7s9r41xu1mf8 → http://localhost:8080/ipfs/QmSsYRx3LpDAb1GZQm7zZ1AuHZjfbPkD6J7s9r41xu1mf8 → http://bafybeicdlctvdhgvhnu5xqjm6tvjzaw3oyllq77deguvllb52hzu3ur76m.ipfs.localhost:8080/`
* `https://sepolia.etherscan.io/address/0x1e4c38098Eb1D368d44Fd59370e68BdC68fCff33`

## Notes

* `tokenURI(uint256 tokenId)`: specific metadata and appearance returned for an NFT conforming to the ERC721 standard.
  
* `abi.encodePacked` function takes multiple arguments of different types (strings, integers, addresses, etc.) and converts them into a sequence of bytes, then concatenates them directly together with `no padding`. The "packed" nature of `abi.encodePacked` makes it ideal for when you want to create a single, tight byte array, like building a URL string.

* `abi.encodePacked` removes length information for dynamic types, making it impossible for `abi.decode` to determine where one encoded value ends and the next begins.

* `abi.encode()` pads elements to 32 bytes, while `abi.encodePacked()` does not.

* When implementing access control for a function specific to a single NFT (identified by `tokenId`), `ownerOf(tokenId)` and `getApproved(tokenId)` functions are essential for checking authorization.
    1. `ownerOf(tokenId):` The function returns the address of the current owner of the  specified tokenId. Your access control logic would compare this result to `msg.sender` to see if the caller is the owner.
    2. `getApproved(tokenId)`: This function returns the address that has been given a specific, one-time approval for this single tokenId.

* To print the value of a Solidity variable to the terminal during the execution of a Foundry test, import `console.sol` from `forge-std` and use the `console.log()` function.

* call vs staticcall:

    | Feature            | `call`                                       | `staticcall`                                     |
    | :----------------- | :------------------------------------------- | :----------------------------------------------- |
    | **State Modification** | Can modify state                             | **Cannot modify state (reverts if attempted)** |
    | **Ether Transfer** | Can send Ether                               | **Cannot send Ether** |
    | **Reentrancy Risk** | High (if not guarded)                        | Low (for state changes)                          |
    | **Primary Use Case** | General interaction, state changes, Ether transfer | Read-only queries, data retrieval                |
    | **Safety** | Less safe for untrusted contracts (due to state changes) | Safer for untrusted contracts (cannot modify your state) |

* `abi.encodeWithSelector` is a function used to encode a function call into a format that the Ethereum Virtual Machine (EVM) can understand and execute. Takes two main types of arguments:
  1. bytes4 selector: This is the 4-byte function selector. You typically obtain this by:
        * Manually hashing the signature: bytes4(keccak256("functionName(type1,type2,...)"))
        * Using a function's `.selector` property (recommended for type-safety since Solidity 0.8.0+): MyContract.myFunction.selector (if MyContract is an interface or a contract instance with myFunction defined).
  2. ... (variable-length list of arguments): These are the values you want to pass to the function, in the correct order and types as defined by the function's signature.
* `abi.encodeWithSelector` requires a pre-calculated function selector (bytes4) as its first argument.

* `EVM` It sequentially reads the bytecode, interpreting specific byte sequences as operational codes (opcodes) to perform computations.

* The data payload (or `calldata`) for a low-level function call in the Ethereum Virtual Machine (EVM) is structured as follows:
    1. `Function Identifier (Selector)`: This is the first 4 bytes of the Keccak-256 hash of the function's signature (e.g., bytes4(keccak256("myFunction(uint256,address)"))). This tells the receiving contract which function to execute.
    2. `ABI Encoded Function Arguments`: Immediately following the 4-byte function selector, the actual arguments (parameters) for that function are appended. These arguments are encoded according to the Ethereum `Application Binary Interface (ABI)` specification, which defines how data types are packed into a compact binary format.

* `abi.encodeWithSignature` allows encoding calldata for a low-level call using the function's string signature directly, without first manually calculating the selector.

* Using the `cast sig "mintNFT(string)"` command, you obtain the 4-byte function selector for a specific function signature.
