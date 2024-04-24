## Cheat commands

* `forge install OpenZeppelin/openzeppelin-contracts-upgradeable --no-commit`
* `forge install OpenZeppelin/openzeppelin-contracts --no-commit`
* `forge install chainaccelorg/foundry-devops --no-commit`

## Notes

* Since proxied contracts do not make use of a constructor, it´s common to move constructor logic to an external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer function so it can only be called once.
* Storage is stored in the proxy, NOT the implementation.
* Proxy (borrowing functions) -> implementation (but NOT use the constructor).
* Proxy -> 1. deploy implementation -> 2. call some "initializer" function.
