# Optimism - NFT smart contract

## General concepts

* Superchain faucet: free testnet ETH.

## Optimism Starter toolkit

Open-source project that provides a template and pre-configured env that streamlines the process of building, testing and deploying smart contracts on the OP network. Streamlines both smart contract and front-end development.

* wagmi: a VanillaJS to connect to a wallet, display ENS and balance information, sign messages, interact with contracts, +.
* Rainbow kit: a React library that makes it easy to add a wallet connection to your decentralized app.
* Vite: a build tool that aims to provide a faster and leaner development experience for modern web projects.

### ERC-2981

#### Specifying default royalty

* ERC-2981 is not aware of the unit of exchange, marketplaces must pay tge royalty in the same unit of exchange.
* Royalty payment= (sale price * royalty amount)/fee denominator. Where fee defaults to 10000 and are expressed in basis points.
