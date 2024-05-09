# Decentralized Autonomous Organizations (DAOs) and Governance

* Any group that is governed by a transparent set of rules found on a blockchain or smart contract.

## Voting Mechanism

* Token based voting.
* Skin in the game voting.
* Proof of personhood or participation.

## Implementation

* On chain voting: for example Compound, cost GAS.
* Off chain voting: replay side transactions in a single transaction to reduce the voting cost, for example send a transaction signed + IPFS + oracle.

### Requirements

* We are going to have a contract controlled by DAO.
* Every transaction that the DAO wants to send has to be voted on.
* We will use ERC20 tokens for voting.

 