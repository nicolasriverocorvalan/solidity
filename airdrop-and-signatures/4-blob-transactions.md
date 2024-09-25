# Blob ( Binary Large Objects) transactions

`EIP-4844`, also known as `Shard Blob Transactions`, is a proposal aimed at introducing a new transaction type (`3`) to Ethereum that allows for the inclusion of large binary data blobs.

## Key features of EIP-4844

* Introduces a new transaction type that includes a large binary data blob.
* These blobs are not directly accessible by the Ethereum Virtual Machine (EVM) but are instead used for off-chain data storage and retrieval.
* Ensures that the data blobs are available for a certain period, which is crucial for the security and functionality of layer-2 solutions and rollups.
* Aims to improve the scalability of the Ethereum network by enabling more efficient data storage and retrieval mechanisms.
* Helps in reducing the load on the main Ethereum chain by offloading data storage to shards.
* Introduces the concept of `versioned hashes` to ensure compatibility and upgradeability of the data storage mechanisms.

## Opcode to get versioned hashes

In the context of `EIP-4844`, an opcode to get `versioned hashes` would be used to retrieve the hash of a data blob, including its version information. This ensures that the data can be correctly interpreted and verified.

```bash
PUSH1 0x01       # Pushes the version number onto the stack
PUSH32 <blob_id> # Pushes the identifier of the data blob onto the stack
VERSIONEDHASH    # A custom opcode that retrieves the versioned hash of the data blob
```
## Point evaluation precompile

In the context of `EIP-4844`, `point evaluation precompile` refers to a specialized function that is precompiled into the Ethereum Virtual Machine (EVM) to efficiently perform point evaluations on polynomial commitments. This is particularly relevant for cryptographic operations and data availability proofs in the context of sharding and layer-2 solutions.

* Polynomial commitments: are cryptographic primitives that allow one to commit to a polynomial and later reveal evaluations of the polynomial at specific points. Used in various cryptographic protocols, including zk-SNARKs and data availability proofs.

* Precompile: a precompile is a function that is implemented natively in the EVM for efficiency reasons. Precompiles are used for operations that are computationally intensive and would be inefficient to implement directly in EVM bytecode.

The point evaluation precompile would be used to efficiently verify data availability proofs. This is crucial for ensuring that the data blobs included in shard blob transactions are available and can be correctly reconstructed.

```bash
PUSH32 <commitment>  # Pushes the polynomial commitment onto the stack
PUSH32 <point>       # Pushes the point at which to evaluate the polynomial onto the stack
PUSH32 <evaluation>  # Pushes the expected evaluation result onto the stack
POINTEVAL            # A custom precompile that performs the point evaluation and verification
```

## Sum up

*  Blobs store data on-chain for a short period of time.
*  We can´t access the data itself, we can access a hash of the data with `BLOBHASH` opcode.
*  Blobs were added because rollups wanted a cheaper way to validate transactions.
*  Flow:
    1. You summit a transactions with a blob, along with some proof od data.
    2. Your contract on-chain access a hash of the blob with the `BLOBHASH` opcode.
    3. It the will pass your `blob-hash` combined with your `proof of data` to the new `point evaluation opcode` to help verify the transaction hash.

