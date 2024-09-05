# Airdrop and signatures

An airdrop happens when a token development team distributes tokens or allows people to claim them. These tokens can be of different types, such as ERC-20, ERC-1155, or ERC-721.

Tokens are typically distributed based on eligibility criteria, such as contributing to the project's GitHub repository or participating in the community. This process helps bootstrap the project by allocating tokens to a list of eligible addresses.

## Merkle Tree

`Merkle tree` is a hierarchical structure where its base consists of **leaf nodes** representing data that has been hashed. The top of the tree is the **root hash**, created by hashing together pairs of adjacent nodes. This process continues up the tree, resulting in a single **root hash** that will represents all the data in the tree.

## Merkle Proofs

`Merkle proofs` will verify that a specific piece of data is part of a Merkle Tree and consist of the hashes of **sibling nodes** present at each level of the tree.

### Example

To prove that Hash B is part of the Merkle Tree, you would provide Hash A (sibling 1) at the first level, and the combined hash of Hash C and Hash D (sibling 2) at the second level as proofs.

This allows the Merkle Tree verifier to reconstruct a root hash and compare it to the expected root hash. If they match, the original data is confirmed to be part of the Merkle tree.

```bash
        Root Hash
           / \
          /   \
         /     \
        /       \
       /         \
    Hash AB      Hash CD
    /  \          /   \
   /    \        /     \
Hash A  Hash B  Hash C  Hash D
```

Proof to verify Hash B:

1. Hash A (sibling at the first level)
2. Hash CD (combined hash of Hash C and Hash D at the second level)

Verification Steps:
1. Combine Hash B and Hash A to get Hash AB.
2. Combine Hash AB and Hash CD to get the Root Hash.
3. Compare the reconstructed Root Hash with the expected Root Hash.

### Applications

Merkle trees are used in `rollups` to verify state changes and transaction order, and in airdrops, allowing specific addresses to claim tokens by being included as leaf nodes in the tree. Merkle proofs are a safer and more efficient way to conduct airdrops than relying on a simple list of addresses to prove that a piece of data (e.g., an address) is part of a group.

## Notes

* [OpenZeppelin MerkleProof library](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/dbb6104ce834628e473d2173bbc9d47f81a9eec3/contracts/utils/cryptography/MerkleProof.sol)
* [The second preimage attack for Merkle Trees in Solidity](https://www.rareskills.io/post/merkle-tree-second-preimage-attack)
