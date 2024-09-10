# ECDSA signature on Ethereum

ECDSA could be used for generating key pairs, create signatures or verify signatures.

## EIP-191

`EIP-191` is a standard for signing and verifying Ethereum messages. It defines a way to sign arbitrary messages in a way that can be securely verified on-chain.

### Key concepts of EIP-191

* `Message Prefix:`: `EIP-191` specifies a prefix to distinguish between different types of messages. The prefix helps prevent replay attacks by ensuring that the signed message is unique and context-specific.

* `Message Structure`: The message structure includes a version byte, which indicates the type of message being signed. The most common version is `0x45`, which is used for arbitrary data.

* `Signing and Verification:` The process involves hashing the message with the prefix and then signing the resulting hash. The signature can be verified on-chain using the `ecrecover` Solidity function to ensure it was signed by the correct address.

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
<hash of the entity verifying this signature, and the verifier details>
<hash of the signed structured message, and the signature details>
```
