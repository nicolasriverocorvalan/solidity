# CCIP Bootcamp - Sending USDC Cross-Chain

With CCIP you get:

* Multiple nodes run by different key holders.
* Three networks all executing and verifying every bridge transaction.
* Separation of responsibilities, with distinct sets of node operators, and with no nodes shared between the transactional DONs and the Risk Management Network.
* Increased decentralization with separate code bases across different implementations.

## Sending USDC Cross-Chain

### Deploy TransferUSDC.sol to Avalanche Fuji

```bash
$make deploy-transfer-usdc-fuji ARGS="--network fuji"
# https://testnet.snowtrace.io/address/0x476d46A0033c08aCa2364B42f5CFa18C6AFbDf09
```

### On AvalancheFuji, call allowlistDestinationChain function

```bash
# CCIP Chain Selector for the Ethereum Sepolia: 16015286601757825753, as the _destinationChainSelector parameter
# true as _allowed parameter

cast send $FUJI_CONTRACT_ADDRESS --rpc-url $FUJI_RPC_URL --private-key=$FUJI_PRIVATE_KEY "allowlistDestinationChain(uint64,bool)" 16015286601757825753 true
# https://testnet.snowtrace.io/tx/0xfd336201d303d026a40672ffb8543802619e003ddf4690ef6676331e78a7905f
```

### On AvalancheFuji, fund TransferUSDC.sol

```bash
Metamask -> fund TransferUSDC.sol(0x476d46A0033c08aCa2364B42f5CFa18C6AFbDf09) with 3 LINK
# https://testnet.snowtrace.io/tx/0x353dca6293f4f0abc49d6107d6a8d10cb4fa1c9c0001c75fd678e6b89c9c3307
```

### On Avalanche Fuji, call approve function on USDC.sol

Go to [Avalanche Fuji Snowtrace Explorer](https://testnet.snowtrace.io/address/0x5425890298aed601595a70AB815c96711a31Bc65/contract/43113/writeProxyContract?chainId=43113) and search for USDC token. Locate the "Contract" tab, then click the "Write as Proxy" tab. Connect your wallet to the blockchain explorer. And finally find the `approve` function. Because USDC token has 6 decimals, 1000000 means that we will approve 1 USDC to be spent on our behalf.

We want to approve `1 USDC` to be spent by the `TransferUSDC.sol` on our behalf. To do so we must provide:
* the address of the `TransferUSDC.sol` smart contract we previously deployed, as spender parameter.
* `1000000`, as value parameter.

```bash
cast send 0x5425890298aed601595a70AB815c96711a31Bc65 --rpc-url $FUJI_RPC_URL --private-key=$FUJI_PRIVATE_KEY "approve(address,uint256)" 0x476d46A0033c08aCa2364B42f5CFa18C6AFbDf09 1000000
# https://testnet.snowtrace.io/tx/0xc0b13856451ed4cc06f0894a716906a43b7fc77bc74cde5dbc58c245914a3cbf
```

### On AvalancheFuji, call transferUsdc function

```bash
# CCIP Chain Selector for the Ethereum Sepolia: 16015286601757825753, as the _destinationChainSelector parameter
# your wallet address (0x64Dd9D94818A2CA2e95c31B084aeF0CC92e86dA2), as the _receiver parameter
# 1000000, as the _amount parameter
# 0, as the _gasLimit parameter

cast send $FUJI_CONTRACT_ADDRESS --rpc-url $FUJI_RPC_URL --private-key=$FUJI_PRIVATE_KEY "transferUsdc(uint64,address,uint256,uint64)" 16015286601757825753 0x64Dd9D94818A2CA2e95c31B084aeF0CC92e86dA2 1000000 0
# https://testnet.snowtrace.io/tx/0x15faf9d59ac92e6016249ec6f829e32024e0fd901eaf0dfdca7855df85cf095f
# https://ccip.chain.link/msg/0x474ad2613904d386b2f42bd9be4d3cc5b38be9a405a4ae2f50813b041a40a7b8
```

## Optimizing Gas Limit Settings in CCIP Messages

* `https://docs.chain.link/ccip/tutorials/ccipreceive-gaslimit`
* [Tenderly](`https://dashboard.tenderly.co/explorer`)

### Foundry local gas estimation

* `https://github.com/smartcontractkit/smart-contract-examples/tree/main/ccip/estimate-gas/foundry`

```bash
$ forge test -vv --isolate            
[⠊] Compiling...
[⠒] Compiling 80 files with Solc 0.8.26
[⠘] Solc 0.8.26 finished in 3.70s
Compiler run successful!

Ran 3 tests for test/SendReceive.t.sol:SenderReceiverTest
[PASS] test_SendReceiveAverage() (gas: 140043)
Logs:
  Number of iterations 50 - Gas used: 11325

[PASS] test_SendReceiveMax() (gas: 146068)
Logs:
  Number of iterations 99 - Gas used: 17352

[PASS] test_SendReceiveMin() (gas: 133858)
Logs:
  Number of iterations 0 - Gas used: 5175

Suite result: ok. 3 passed; 0 failed; 0 skipped; finished in 38.22ms (3.58ms CPU time)
```

| Test Name                | Gas Used | Number of Iterations | Logs Gas Used |
|--------------------------|----------|----------------------|---------------|
| test_SendReceiveMin      | 133858   | 0                    | 5175          |
| test_SendReceiveAverage  | 140043   | 50                   | 11325         |
| test_SendReceiveMax      | 146068   | 99                   | 17352         |
