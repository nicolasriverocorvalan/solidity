# Airdrop and Signatures

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
* [Merkle Generator and Prover in Solidity](https://github.com/dmfxyz/murky)

## Execute

```bash
## generate Merkle json input
forge script script/MerkleInputGenerator.s.sol:MerkleInputGenerator -vvvv

## generate Merkle tree
forge script script/GenerateMerkle.s.sol:GenerateMerkle -vvvv
```

## EIP-191

`EIP-191` is a standard for signing and verifying Ethereum messages. It defines a way to sign arbitrary messages in a way that can be securely verified on-chain.

This is particularly useful for off-chain message signing, such as in the context of airdrops, where users might need to prove their eligibility by signing a message.

### Key concepts of EIP-191

* `Message Prefix:`: `EIP-191` specifies a prefix to distinguish between different types of messages. The prefix helps prevent replay attacks by ensuring that the signed message is unique and context-specific.

* `Message Structure`: The message structure includes a version byte, which indicates the type of message being signed. The most common version is `0x45`, which is used for arbitrary data.

* `Signing and Verification:` The process involves hashing the message with the prefix and then signing the resulting hash. The signature can be verified on-chain using the `ecrecover` function to ensure it was signed by the correct address.

### Structure of EIP-191 messages

* `0x19`: This is a fixed prefix byte that indicates the start of an EIP-191 message. It helps distinguish `EIP-191` messages from other types of data.

* `<1 byte version>`: This byte specifies the version of the message format. Different versions can define different structures for the message.

    1. `0x00`: used for Ethereum signed messages. This version is used for signing arbitrary messages with the Ethereum prefix.
   
    2. `0x01`: used for signing structured data as defined in `EIP-712`.

    3. `0x45`: used for signing arbitrary data without any specific structure.

* `<version specific data>`: This part of the message can vary depending on the version byte. For version `0x45`, this section is typically empty or can include additional data specific to the version.

* `<data to sign>`: this is the actual data that needs to be signed. It can be any arbitrary data that the user wants to sign.

## EIP-712

`EIP-712` provides a standard for signing and verifying typed structured data. It is designed to improve the security and usability of off-chain message signing by providing a clear and `human-readable` format for the data being signed.

### Structure of EIP-712 messages

* `0x19`: This is a fixed prefix byte that indicates the start of an `EIP-191` message. It helps distinguish `EIP-191` messages from other types of data.

* `0x01`: This byte specifies the version of the message format. In this case, `0x01` indicates that the message follows the `EIP-712` standard for structured data.

* `<domain separator>` -> `<hashStruct(eip712Domain)>`: The domain separator is a unique identifier for the context in which the data is being signed. It includes information such as `the name and version of the DApp, the chain ID, and the contract address`. The domain separator helps prevent `replay attacks` across different domains.

```bash
struct EIP712Domain {
    string name;
    string version;
    uint256 chainId;
    address verifyingContract;
};

bytes32 public constant EIP712DOMAIN_TYPEHASH = 
    keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");

eip_domain_separator_struct = EIP712Domain({
    "name": "MyDApp",
    "version": "1",
    "chainId": 1,
    "verifyingContract": address(this)
});

i_domain_separator = keccak256(
    abi.encode(
        EIP712DOMAIN_TYPEHASH,
        keccak256(bytes(eip_domain_separator_struct.name)),
        keccak256(bytes(eip_domain_separator_struct.version)),
        eip_domain_separator_struct.chainId,
        eip_domain_separator_struct.verifyingContract
    )
);
```

* `<hashStruct(message)>`: This is the hash of the structured data being signed. The data is hashed according to the defined types and the `EIP-712` encoding rules.

```bash
struct Message {
    uint256 number;
};

bytes32 public constant MESSAGE_TYPEHASH = keccak256("Message(uint256 number)");

bytes32 hashedMessage = keccak256(abi.encode(MESSAGE_TYPEHASH, Message({ number: message })));
```

### EIP-712 sum up

```bash
0x19 
0x01 
<hash of who verifies this signature, and what the verifier looks like> 
<hash of signed structured message, and what the signature looks like>
```

## ECDSA

1. Generating key pairs
2. Create signatures
3. Verify signatures

### SECP256k1 Curve

The specific curve used in `ECDSA` in Ethereum is called the `secp256k1`curve. This curve is particularly significant in the context of Ethereum and other cryptocurrencies because it underpins the security of digital signatures. One notable characteristic of the `secp256k1` curve is that for every `x-coordinate` on the curve, there are two valid signatures. This means that if a malicious actor knows one signature, they can compute the second one. This vulnerability is known as `signature malleability`, which can potentially lead to replay attacks where a valid data transmission is maliciously or fraudulently repeated or delayed.

There are several constants associated with the `SECP 256k1 curve` that are crucial for its operation. One of these is the `Generator Point (G)`, which is a predefined point on the curve used in the generation of public keys. Another important constant is `n`, a prime number that defines the length of the private key. These constants are fundamental to the cryptographic processes that ensure the security and integrity of transactions on the Ethereum network.

* **Generator Point (G)**: A predefined point on the curve.
* **n**: A prime number defining the length of the private key.

The public key is an elliptic curve point calculated by multiplying the private key with the generator point `G`. This operation ensures that the public key is derived in a secure manner, making it computationally infeasible to reverse-engineer the private key from the public key. This relationship between the private key, the generator point, and the public key is central to the security of ECDSA and, by extension, the security of Ethereum transactions.

### ECDSA Signatures

ECDSA signatures consist of three integers `r`, `s`, and `v`.

1. The message is hashed
2. A random number `k` (the `nonce`) is generated.
3. Calculating signature components:
   * `r`: `x` point on the `secp256k1` curve, resulting from multiplying the nonce `k` by the generator point `G`.
   * `s`: proof the signer knows the private key, calculated using the nonce `k`, the hash of the message, the private key, and the `r` value.
   * `v`: indicates the `polarity` (positive or negative `y-axis`) of the point on the elliptic curve.

### Compute keys

* `privKey`: random integer within the range `0 to n-1`, where `n` is the order (a large prime number that defines the length of the private key).

* `pubKey = privKey.G` , where `.` denotes modular multiplication. `pubKey` is an elliptic curve point.

* `elliptic curve discrete logarithm problem`: if we times 2 big integers together, the output being a giant integer, using just the output we cannot feasibly calculate the inputs. Impossible to calculate `p` from `pubKey = p.G`. Since point arithmetic in a finite field does not support division, a computer would instead have to use brute force to determine `p` (even `G` is known).

### Compute signature

Signatures are created by combining a hash of a `message` with the `privKey`.

1. Using ECDSA algorithm, hash the message using `SHA256`.
2. Generate a secure random number K, the `nonce`.
3. Calculate a randon number `R = k.G` , which is the `nonce` times the `generator point`. 
4. `R = (x,y)`. The result of the multiplication`R = k.G` is a point on the elliptic curve, represented as `R = (x, y)`. 
5. Compute `r`.  `r = x mod n`. The value `r` is derived from the `x-coordinate` of the point `R`. Specifically, `r` is calculated as `r = x mod n`, where `n` is a prime number that defines the length of the `privKey`. This modular operation ensures that `r` is within the appropriate range for the cryptographic operations that follow.
6. Compute `s` using the `nonce` (`k`), the `hash of the message` (`z`), the `privKey` (`d`), `r`, and the order `n`.

`[ s = k^{-1} . (z + r . d) \mod n ]`

7. Compute `v`. The `recovery_id` is an integer that helps in recovering the public key from the ECDSA signature. It can be either `0 or 1`, indicating which of the two possible `y-coordinates` was used in the signature.

The addition of `27` is a convention that was adopted to distinguish Ethereum signatures from other ECDSA signatures.

### ECDSA signature verification

1. Input components:
    - message: the original message that was signed.
    - signature: the ECDSA signature, consisting of two components `r` and `s`.
    - pubKey: the pubKey (`Q`) corresponding to the private key used to create the signature.
2. Hash the message:
    - compute the hash (`z`) of the message using SHA-256.
3. Verification step:
   1. Ensure that `r` and `s` are integers in `range [1, n-1]`, where `n` is the order of the elliptic curve.
   2. Compute `w: [ w = s^{-1} \mod n ]`. Calculate the modular inverse of `s` modulo `n`.
   3. Compute `u1` and `u2` using the hash `z`, the signature component `r`, and `w`. `w: [ u1 = z . w \mod n ] [ u2 = r . w \mod n ]`
   4. Compute `[ R = u1 . G + u2 . Q ]`, the elliptic curve point `R` using the curve's generator point `G` and the public key `Q`.
   5. Ensure that `R` is not the point at infinity.
   6. Convert the `x-coordinate` of `R` to an `integer xR`.
   7. Verify that `r` is congruent to `xR modulo n`: `[ r \equiv xR \mod n ]`

***Important***: The `s` value in an ECDSA signature must be restricted to ensure security and prevent certain types of attacks, such as `signature malleability`. `s` should be restricted to the lower half of the curve's `order n`. This is known as `canonical` or `normalized` signatures.

***Using `ecrecover` directly can lead to signature malleability.***

## Transaction types

### Type 0 (legacy transactions)

This is the oldest transaction type, specified when using the `--legacy` flag. It was the first standard Ethereum transaction before the introduction of newer types.

  