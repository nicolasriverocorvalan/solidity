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
* `abi.encode` pads every argument to a full 32 bytes.
* When implementing access control for a function specific to a single NFT (identified by `tokenId`), `ownerOf(tokenId)` and `getApproved(tokenId)` functions are essential for checking authorization.
    1. `ownerOf(tokenId):` The function returns the address of the current owner of the  specified tokenId. Your access control logic would compare this result to `msg.sender` to see if the caller is the owner.
    2. `getApproved(tokenId)`: This function returns the address that has been given a specific, one-time approval for this single tokenId.
* Fo print the value of a Solidity variable to the terminal during the execution of a Foundry test, import `console.sol` from `forge-std` and use the `console.log()` function.
