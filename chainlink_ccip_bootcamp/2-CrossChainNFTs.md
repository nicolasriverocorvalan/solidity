# CCIP Bootcamp - Cross-Chain NFTs

A cross-chain NFT is a smart contract that can exist on any blockchain, abstracting away the need for users to understand which blockchain they’re using.

## How Do Cross-Chain NFTs Work?

At a high level, an NFT is a digital token on a blockchain with a unique identifier different from any other token on the chain.

Any NFT is implemented by a smart contract that is intrinsically connected to a single blockchain. The smart contract is arguably the most important part of this equation because it controls the NFT implementation: How many are minted, when, what conditions need to be met to distribute them, and more. This means that any cross-chain NFT implementation requires at least two smart contracts on two blockchains and interconnection between them.

## Cross-chain NFTs can be implemented in three ways

1. `Burn-and-mint`: An NFT owner puts their NFT into a smart contract on the source chain and burns it, in effect removing it from that blockchain. Once this is done, an equivalent NFT is created on the destination blockchain from its corresponding smart contract. This process can occur in both directions.

2. `Lock-and-mint`: An NFT owner locks their NFT into a smart contract on the source chain, and an equivalent NFT is created on the destination blockchain. When the owner wants to move their NFT back, they burn the NFT and it unlocks the NFT on the original blockchain.

3. `Lock and unlock`: The same NFT collection is minted on multiple blockchains. An NFT owner can lock their NFT on a source blockchain to unlock the equivalent NFT on a destination blockchain. This means only a single NFT can actively be used at any point in time, even if there are multiple instances of that NFT across blockchains.

## Implementing Burn-and-Mint model

To implement Burn-and-Mint model using Chainlink CCIP, we will on cross-chain transfer function burn an NFT on the source blockchain (Arbitrum Sepolia) and send the cross-chain message using Chainlink CCIP. We will need to encode to and from addresses, NFT's tokenId and tokenURI so we can mint exactly the same NFT on the destination blockchain once it receives a cross-chain message.

CCIP config details

## CCIP Config Details

| Configuration       | Arbitrum Sepolia                              | Ethereum Sepolia                              |
|---------------------|-----------------------------------------------|-----------------------------------------------|
| **Chain Selector**  | 3478487238524512106                           | 16015286601757825753                          |
| **CCIP Router Address** | 0x2a9c5afb0d0e4bab2bcdae109ec4b0c4be15a165 | 0x0BF3dE8c5D3e8A2B34D2BEeB17ABfCeBaf363A59     |
| **LINK Token Address**  | 0xb1D4538B4571d411F07960EF2838Ce337FE1E80E | 0x779877A7B0D9E8603169DdbD7836e478b4624789     |

## Cross-Chain NFTs

### Deploy XNFT.sol to Ethereum Sepolia

```bash
$make deploy-nft-sepolia ARGS="--network sepolia"
# https://sepolia.etherscan.io/address/0x27C97B7E4a3FE199b90b74115c0D70BbDeB5A433
```

### Deploy XNFT.sol to Arbitrum Sepolia

```bash
$make deploy-nft-arbitrum ARGS="--network arbitrum"
# https://sepolia.arbiscan.io/address/0xA32C97afA6B5a7Ca936A7aaeeaA1C2b58Bc75A7C
```

### On Ethereum Sepolia, call enableChain function

```bash
# 3478487238524512106 is the CCIP Chain Selector for Arbitrum Sepolia network
# 0x97a657c90000000000000000000000000000000000000000000000000000000000030d40 is the bytes version of CCIP extraArgs' default value with 200_000 gas set for gasLimit, as ccipExtraArgs parameter
# $python3.11 extra-args.py 
# CCIP Extra Args: 0x97a657c90000000000000000000000000000000000000000000000000000000000030d40

cast send $SEPOLIA_CONTRACT_ADDRESS --rpc-url $SEPOLIA_RPC_URL --private-key=$SEPOLIA_PRIVATE_KEY "enableChain(uint64,address,bytes)" 3478487238524512106 $ARBITRUM_CONTRACT_ADDRESS 0x97a657c90000000000000000000000000000000000000000000000000000000000030d40
# https://sepolia.etherscan.io/tx/0x0a1b9ece80fe23eab9e9bf3802c8a8d9bc58840307ba75f00e4518be207065b4
```

### On Arbitrum Sepolia, call enableChain function

```bash
# 16015286601757825753 is the CCIP Chain Selector for the Ethereum Sepolia network

cast send $ARBITRUM_CONTRACT_ADDRESS --rpc-url $ARBITRUM_RPC_URL --private-key=$ARBITRUM_PRIVATE_KEY "enableChain(uint64,address,bytes)" 16015286601757825753 $SEPOLIA_CONTRACT_ADDRESS 0x97a657c90000000000000000000000000000000000000000000000000000000000030d40
# https://sepolia.arbiscan.io/tx/0xef07b0e60cb213651c40eb2fa4ba7df67201a320987c2f65fc2bf276b1fe9ec0
```

### On Arbitrum Sepolia, fund XNFT.sol with 3 LINK

```bash
# 3 LINK -> 0xA32C97afA6B5a7Ca936A7aaeeaA1C2b58Bc75A7C
# https://sepolia.arbiscan.io/tx/0x9b8cf8fb2c63ae36e3fb299ef2da8333fedbec2aad60f770ac96a9f4d88279ed
```

### On Arbitrum Sepolia, mint new xNFT

```bash
cast send $ARBITRUM_CONTRACT_ADDRESS --rpc-url $ARBITRUM_RPC_URL --private-key=$ARBITRUM_PRIVATE_KEY "mint()"

# https://sepolia.arbiscan.io/tx/0xed637511b8ea18caf34b17aa3614ca9369c5ed34c4f6d592fff9c933f84593f7
```

### On Arbitrum Sepolia, crossTransferFrom xNFT

```bash
# https://sepolia.arbiscan.io/token/0xa32c97afa6b5a7ca936a7aaeeaa1c2b58bc75a7c

# Parameters:
# your EOA address, as the from parameter -> 0x64Dd9D94818A2CA2e95c31B084aeF0CC92e86dA2
# address of an EOA on other chain where you want to cross-transfer your NFT, can be your EOA address, as to parameter
# the ID of a xNFT you want to cross-transfer, as tokenId parameter
# CCIP Chain Selector of Ethereum Sepolia blockchain -> 6015286601757825753, as the destinationChainSelector parameter
# 1 which stands that we are paying for CCIP fees in LINK, as the payFeesIn parameter

cast send $ARBITRUM_CONTRACT_ADDRESS --rpc-url $ARBITRUM_RPC_URL --private-key=$ARBITRUM_PRIVATE_KEY "crossChainTransferFrom(address,address,uint256,uint64,uint8)" 0x64Dd9D94818A2CA2e95c31B084aeF0CC92e86dA2 0x64Dd9D94818A2CA2e95c31B084aeF0CC92e86dA2 0 16015286601757825753 1
# https://sepolia.arbiscan.io/tx/0x293df20ca84c699717a6de013e28b259599341a4f5c7f9e27ab1968845b08388
# https://ccip.chain.link/msg/0xd6d69ca19ea57c8fb714008dcc5bc3435ea5d76a63862e116d825a2b11b9e3c6
```

Once cross-chain NFT arrives to Ethereum Sepolia, you can manually display it inside your Metamask wallet. Navigate to the `NFT` tab and hit the `Import NFT` button. Fill in XNFT.sol smart contract address (0x27C97B7E4a3FE199b90b74115c0D70BbDeB5A433) on Ethereum Sepolia and token ID you received (0).

```bash
# https://sepolia.etherscan.io/tx/0x14e69c6de57872918e6b234a02c46c26a23c99a092580dfc864d313d3d03e87a
# https://sepolia.etherscan.io/token/0x27c97b7e4a3fe199b90b74115c0d70bbdeb5a433
```

## Testing Cross-Chain contracts using Chainlink Local

* `https://github.com/smartcontractkit/chainlink-local`

###  Write a unit test for our XNFT.sol smart contract

When you compile Solidity code, the two primary outputs are `Application Binary Interface (ABI)` and `EVM bytecode`.

`EVM bytecode` is the machine-level code that the Ethereum Virtual Machine executes. It is what gets deployed to the Ethereum blockchain. It's a low-level, hexadecimal-encoded instruction set that the EVM interprets and runs. The bytecode represents the actual logic of the smart contract in an executable form.

`ABI` is essentially a `JSON-formatted` text file that describes the functions and variables in your smart contract. When you want to interact with a deployed contract (e.g., calling a function from a web application), the `ABI` is used to encode the function call into a format that the EVM can understand. It serves as an interface between your high-level application (like a JavaScript front-end) and the low-level bytecode running on Ethereum. The ABI includes details about each function's name, return type, visibility (public, private, etc.), and the types of its parameters.

Anytime your message is not delivered due to error on the receiver side, `CCIP Explorer` will display the error message. However, if `ABI` is unknown to explorer (for example you haven't verified smart contract's source code on Block explorer) it will display its original content instead of human readable error message.

Couple of tools that we can use:

* `https://bia.is/tools/abi-decoder/`
* Foundry's `cast abi-decode`
* `https://github.com/smartcontractkit/ccip/blob/ccip-develop/core/scripts/ccip/ccip-revert-reason/main.go`

## Notes

* If you are transferring only tokens, gasLimit should be set to 0 because there is no `ccipReceive` function.
* The `extraArgs` should mutable if you want to make your dApp compatible with future CCIP upgrades (https://docs.chain.link/ccip/best-practices#using-extraargs).
* `https://cll-devrel.gitbook.io/chainlink-local-documentation`
* `https://github.com/smartcontractkit/ccip-cross-chain-name-service`
