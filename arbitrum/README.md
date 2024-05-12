# Layer-2 rollups

Layer-2 rollups consist of Optimistic rollups and ZK-rollups. Both are “true layer-2 solutions”, which means they are able to execute a large volume of transactions at high speed and low cost and then verify this bundle of transactions on layer 1. 

With Optimistic rollups, we “optimistically believe” that these transactions really happened on layer 2. These rollups are “optimistic” because the bundles are considered “innocent until proven guilty” by fraud proofs and are optimistically assumed to be correct when posted to layer 1 unless a challenge has been submitted during the 7-day challenge period.

## Arbitrum

## Chainlink L2 Sequencer Health Flag

Consists of three actors:

1. Chainlink Cluster (a group of validator nodes)—this executes the OCR Job every heartbeat “T” (the minimum frequency at which the Chainlink feed is configured to be updated).
2. The actual OCR feed reporting the Sequencer status—this could be used for external users on layer 1 to check OR protocol (e.g. Arbitrum) status.
3. Validator: this gets triggered by the OCR feed and executes the raise or lower flag action if the current answer is different from the previous one.

### Notes

* `https://bridge.arbitrum.io/`
* `https://sepolia.arbiscan.io/`
* `forge test --mt testGetPrice -vv --rpc-url $ARBITRUM_SEPOLIA_RPC_URL`
