# Foundry
* testnet: Alchemy/Infura

## Cheat sheet
* forge init --force .
* forge compile (out folder)
* anvil
* forge create SimpleStorage --rpc-url http://127.0.0.1:8545 --interactive
* forge script script/DeploySimpleStorage.s.sol --rpc-url http://127.0.0.1:8545 --broadcast --private-key [prK] // prK-> Anvil test key, do not use this command in prod
* hex to dec: cast --to-base 0x714c2 dec
