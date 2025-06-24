# ECDSA signature on Ethereum

ECDSA could be used for generating key pairs, create signatures or verify signatures.

## EIP-191

`EIP-191` is a standard for signing and verifying Ethereum messages. It defines a way to sign arbitrary messages in a way that can be securely verified on-chain.

### Key concepts of EIP-191

* `Message Prefix:`: `EIP-191` specifies a prefix to distinguish between different types of messages. The prefix helps prevent replay attacks by ensuring that the signed message is unique and context-specific.

* `Message Structure`: The message structure includes a version byte, which indicates the type of message being signed. The most common version is `0x45`, which is used for arbitrary data.

* `Signing and Verification:` The process involves hashing the message with the prefix and then signing the resulting hash. The signature can be verified on-chain using the `ecrecover` Solidity function to ensure it was signed by the correct address.

### Structure of EIP-191 messages

1. `Section 1`: `0x19 (decimal value 25)`: This is a fixed prefix byte that indicates the start of an EIP-191 message. It helps distinguish `EIP-191` messages from other types of data.

2. `Section 2`: `<1 byte version>`: This byte specifies the version of the message format. Different versions can define different structures for the message.
    a. `0x00`: used for Ethereum signed messages. This version is used for signing arbitrary messages with the Ethereum prefix.
    b. `0x01`: used for signing structured data as defined in `EIP-712`.
    c. `0x45`: used for signing arbitrary data without any specific structure (personal sign messages).

3. `Section 3`: `<version specific data>`: This part of the message can vary depending on the version byte.
    * For version `0x01`, you have to provide the validator address.
    * For version `0x45`, this section is typically empty or can include additional data specific to the version.

4. `Section 4`: `<data to sign>`: this is the actual data that needs to be signed. It can be any arbitrary data that the user wants to sign.

## EIP-712 (Signatures and Verification)

`EIP-712` provides a standard for signing and verifying typed structured data. It is designed to improve the security and usability of off-chain message signing by providing a clear and `human-readable` format for the data being signed.

Structured the data to sign, and also version specific data.

### Structure of EIP-712 messages

`keccak256(0x19 || 0x01 || domainSeparator || messageHash)`

```bash
0x19 
0x01
domain separator: hash of who verifies this signature, and what the verifier looks like
messageHash: hash of the signed structured message, and what the signature looks like
```

1. `Section 1`: `0x19`: This is a fixed prefix byte that indicates the start of an `EIP-191` message. It helps distinguish `EIP-191` messages from other types of data.

2. `Section 2`: `0x01`: This byte specifies the version of the message format. In this case, `0x01` indicates that the message follows the `EIP-712` standard for structured data.

3. `Section 3`: `<domain separator>` -> `<hashStruct(eip712Domain)>`:

The domain separator is a unique `32-byte hash` that identifies the specific context of a signature (e.g., your DApp on a particular network). It is calculated as follows:
   1. `Start with the blueprint`: take the `EIP712DOMAIN_TYPEHASH`, which is the keccak256 hash of the EIP712Domain struct's definition string. This acts as a unique identifier for the data structure. The typeHash is a keccak256 hash of a string that defines the structure of your message.
   2. `Gather the data`: you get the specific values for your domain, such as the name, version, chainId, and verifyingContract address.
   3. `Encode and pack`: create a single, tightly packed byte string using `abi.encode`. The items are encoded in order:
        1. The `EIP712DOMAIN_TYPEHASH` comes first.
        2. This is followed by the individual pieces of data from your struct (with `string` and `bytes` values being keccak256 hashed first, as per the EIP-712 standard).
   4. `Final hash`: compute the keccak256 hash of the entire byte string created in Step 3. This final hash is the domain separator.

```solidity
struct EIP712Domain {
    string  name;              // The human-readable name of the signing domain, e.g., "MyDApp"
    string  version;           // The current version of the signing domain
    uint256 chainId;           // The EIP-155 chain ID of the network
    address verifyingContract; // The address of the contract that will verify the signature
}

bytes32 public constant EIP712DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");

eip_domain_separator_struct = EIP712Domain({
    "name": "MyDApp",
    "version": "1",
    "chainId": 1,
    "verifyingContract": address(this)
});

domain_separator = keccak256(
    abi.encode(
        EIP712DOMAIN_TYPEHASH,
        keccak256(bytes(eip_domain_separator_struct.name)),
        keccak256(bytes(eip_domain_separator_struct.version)),
        eip_domain_separator_struct.chainId,
        eip_domain_separator_struct.verifyingContract
    )
);
```

4. `Section 4`: `<hashStruct(message)>`: is the function that turns a human-readable, structured message into a single, unique, and secure 32-byte hash. The primary goal is to create a deterministic fingerprint of the message that is tied to both its data and its structure.

`hashStruct(message) = keccak256( abi.encode(messageTypeHash, messageField1, messageField2, ...) )`

```solidity
struct Message {
    address from;
    address to;
    uint256 amount;
}

bytes32 public constant MESSAGE_TYPEHASH = keccak256("Message(address from,address to,uint256 amount)");

Message memory message_to_sign = Message({
    from: 0x70997970C51812dc3A010C7d01b50e0d17dc79C8,
    to: 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC,
    amount: 1000
});

bytes32 messageHash = keccak256(
    abi.encode(
        MESSAGE_TYPEHASH,         // The blueprint's hash
        message_to_sign.from,     // The actual data for each field
        message_to_sign.to,
        message_to_sign.amount
    )
);
```

`Final Hash = keccak256(abi.encodePacked("\x19\x01", domainSeparator, messageHash))`
