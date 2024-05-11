# Stablecoins

## Functions of money

1. Storage of value: allow people to preserve wealth over time.
2. Unit of account: provide a common measure of value to price goods and services.
3. Medium of exchange: enable transactions between parties via a payment method.

## Categorization

1. Relative Stability (Pegged/anchored or floating)
    * Pegged (anchored) stablecoins: Pegged to the value of another asset like the US dollar. Examples:USDC, Tether, DAI.
    * Floating (unpegged) stablecoins: Not pegged to any external asset. Stability is maintained via supply and demand mechanisms. Example: RAI stablecoin.
2. Stability Method (Governed or Algorithmic)
    * Algorithmic: Stability is maintained programmatically via a decentralized algorithm. Examples: DAI, Frax.
    * Governed (centralized): Stability is controlled manually by a central party. Examples: USDC, Tether.   
3. Collateral type (Endogenous or Exogenous)
    * Exogenous: Collateral comes from outside the stablecoin's ecosystem. If stablecoin fails, collateral is unaffected. Examples: DAI (ETH collateral), USDC (USD fiat collateral).
    * Endogenous: Collateral comes from inside the stablecoin's ecosystem. If stablecoin fails, collateral fails too. Example: TerraUSD (LUNA collateral).

## Notes

* `https://defillama.com/`

## Implementation

1. Relative Stability: pegged -> $1.00
   1. Chainlink Price feed.
   2. Set a function to exchange ETH and BTC -> $
2. Stability Mechanism (Minting): Algorithmic (Decentralized)
   1. People can only mint the stablecoin with enough collateral (coded)
3. Collateral: Exogenous (Crypto)
   1. ETH (wrap ERC20 version of ETH)
   2. BTC (wrap ERC20 version of BTC)

