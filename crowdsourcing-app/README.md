## Goal
1. Get funds from users.
2. Withdraw funds.
3. Set a minimun funding in USD (5 USD).
4. Use Chainlink data feeds (https://data.chain.link).
5. Create a Library.
6. GAS optimization (vars: constant/inmutable; replace 'require' for custom errors)

## Transactions fields
* nonce: tx count for the account.
* gas price: price per unit of gas (in wei).
* gas limit: max gas that the tx can use.
* to: address that the tx is sent to.
* value: amount of wei to send.
* data: what to send to the TO address.
* v, r, s: components of tx signature.

## Notes
* Blockchain Oracle: Any device that interacts with the oof-chain world to provide external data or computation to smart contracts.
* 1e18 = 1 ETH = 1 * 10 ** 18.
* Library: similar to contracts but you can´t declare any state variable and you can´t send ether. A library is embedded into the contract if all functions are internal.
* constant: the value has to be constant at compile time and it has to be assigned where the variable is declared.
* 'Receive/Fallback' special fuctions:
```
    // Explainer from: https://solidity-by-example.org/fallback/
    // Ether is sent to contract
    //      is msg.data empty?
    //          /   \ 
    //         yes  no
    //         /     \
    //    receive()?  fallback() 
    //     /   \ 
    //   yes   no
    //  /        \
    //receive()  fallback()
```
