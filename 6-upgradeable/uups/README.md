## Cheat commands

* `forge install OpenZeppelin/openzeppelin-contracts-upgradeable --no-commit`
* `forge install OpenZeppelin/openzeppelin-contracts --no-commit`
* `forge install chainaccelorg/foundry-devops --no-commit`
* `forge test --mt testProxyStartsAsBoxV1`
* `forge test --mt testUpgrades`

## Notes

* Since proxied contracts do not make use of a constructor, it´s common to move constructor logic to an external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer function so it can only be called once.
* Storage is stored in the proxy, NOT the implementation.
* Proxy (borrowing functions) -> implementation (but NOT use the constructor).
* Proxy -> 1. deploy implementation -> 2. call some "initializer" function.

## Sepolia

- BoxV1 contract: https://sepolia.etherscan.io/address/0x00894593BAE7463Bb1917Fe73AC0C81309E7C1B0#code
- ERC1967Proxy: https://sepolia.etherscan.io/address/0x57BcA52176D102FA5e5FA3c43A6a66905553Fcb9#code
- BoxV2 contract: https://sepolia.etherscan.io/address/0xAb70Ca11a367424602fa2972bb94BfFEDE29FdA0#code
```bash
$ cast call 0x57BcA52176D102FA5e5FA3c43A6a66905553Fcb9 "getNumber()" --rpc-url $SEPOLIA_RPC_URL`
0x0000000000000000000000000000000000000000000000000000000000000000
$ cast send 0x57BcA52176D102FA5e5FA3c43A6a66905553Fcb9 "setNumber(uint256)" 77 --rpc-url $SEPOLIA_RPC_URL --private-key $SEPOLIA_PRIVATE_KEY
$ cast call 0x57BcA52176D102FA5e5FA3c43A6a66905553Fcb9 "getNumber()" --rpc-url $SEPOLIA_RPC_URL                                          
0x000000000000000000000000000000000000000000000000000000000000004d
$ cast --to-base 0x000000000000000000000000000000000000000000000000000000000000004d dec
77
```
