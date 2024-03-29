# Optimism - NFT smart contract

## General concepts

* NFT: are unique digital assets that represent ownership of proof of authenticity of a specific item.
* Minting NFT: refers to the process of creating a new unique token.
* Burning an NFT: is an irreversible action, and once burned, the NFT cannot be recovered.
* Superchain Faucet: free testnet ETH.
* OP Goerli: a public testnet where you can conduct further testing.
* ERC-721 Standard: interface for NFT on the ETH blockchain. Adds support for storing and managing token metadata (URI - Uniform Resource Identifier).
* ERC-2981 Standard: Is an EIP (Ethereum Improvement Proposal) that introduce a standard interface for NFTs with royalty support. Represents a mechanism for creators to receive royalties whenever their NFT are sold or traded on a marketplace, allowing contracts to signal a royalty amount to be paid to the NFT creator or right holder every time the NFT is sold or re-sold. The royalty payment must be voluntary, as executing transfers between wallets does not always imply a sale ocurred.

## Optimism Starter toolkit

Open-source project that provides a template and pre-configured env that streamlines the process of building, testing and deploying smart contracts on the OP network. Streamlines both smart contract and front-end development.

* Foundry: ETH development framework that facilitates the creation, testing and deployment of smart contracts.
* Forge: testing framework that ships with Foundry. Is a command line tool.
* wagmi: a VanillaJS to connect to a wallet, display ENS and balance information, sign messages, interact with contracts, +.
* Rainbow kit: a React library that makes it easy to add a wallet connection to your decentralized app.
* Vite: a build tool that aims to provide a faster and leaner development experience for modern web projects.

### Main directories

* contracts/src: front-end code
* contracts/test: test files
* contracts/script: additional Solidity scripts needed. Scripts run on the Foundry EVM backend (dry-run capabilities)
* package.json: this file is part of the Node.js project and manages dependencies, scripts, and project metadata. It specifies the required packages and scripts used in your project.

### ERC-2981

#### Specifying default royality

* ERC-2981 is not aware of the unit of exchange, marketplaces must pay tge royalty in the same unit of exchange.
* Royalty payment= (sale price * royalty amount)/fee denominator. Where fee defaults to 10000 and are expressed in basis points.7

### Testing smart contracts - Forge

* All test are written in Solidity. If a test function reverts, the test is considered a failure, otherwise, it passes.
* Any contract with a function starting with "test" is recognized as a test.
* Best practices:
  * Location: contracts/test
  * Each file name ends with ".t.sol"
  * Utilize the Forge Standard library's test contract (forge-std/Test.sol)

### Contract deployed

https://goerli-optimism.etherscan.io/address/0x4fd4901345450e37641fbfdbcb8894956490fa13#code
