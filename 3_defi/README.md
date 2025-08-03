## Notes

* https://defillama.com/

* https://docs.soliditylang.org/en/latest/natspec-format.html

* `Exogenous` collateral's value exists independently of the stablecoin itself, while `endogenous` collateral's value is tied to the protocol itself.

* `healthFactor` is a numerical representation of the user's collateralization level relative to their stablecoin debt.

* `Solidity does not inherently support floating-point numbers`. All calculations in Solidity are performed using integers. To represent decimal values, smart contracts use a convention where token amounts are stored as large integers, with the decimals variable indicating how many decimal places to implicitly "shift" to get the human-readable value. For example, an ERC-20 token with 18 decimals means that 1 token is actually represented as `1 * 10^18` internally.

* In smart contract development, internal or private helper functions are introduced when refactoring features that involve actions performed by one address on behalf of another, to decouple core logic from the transaction sender (`msg.sender`) and allow specifying different source/target addresses.

* The piece of data from Chainlink's `latestRoundData` function that is most directly used to check if a price feed update is recent is `the timestamp of when the round was last updated (updatedAt).` Here's how it works in practice:

    - A smart contract calls latestRoundData() to get the latest price information.
    - It receives several values, including updatedAt, which is a Unix timestamp.
    - The contract then compares this updatedAt timestamp with the current block's timestamp (block.timestamp).
    - By calculating the difference (block.timestamp - updatedAt), the contract can determine how much time has passed since the last price update.
    - If this duration exceeds a predefined threshold (e.g., 1 hour), the contract can consider the data to be stale and reject the transaction or trigger a safety mechanism.

## Testing

* `Invariant Testing`: Focuses on properties (invariants) that should always be true, regardless of how the contract interacts or its state changes. It typically involves fuzzing or property-based testing to explore a vast number of interactions and state transitions, asserting that these invariants are never violated. This is crucial for complex smart contract systems where many execution paths exist.

* `Unit Testing`: Checks individual functions or components in isolation, not necessarily how properties hold across an entire system with various interactions.

* `Integration Testing`: Checks how different parts of a system (or different contracts) work together, but it typically uses predefined sequences of interactions rather than exploring a vast state space for invariant violations.

* What is a likely benefit of configuring a stateful fuzz testing tool to immediately fail a test run if *any* transaction reverts? It helps validate that test sequences, especially guided ones (e.g., using Handlers), are constructed correctly and only perform valid operations.

* `foundry.toml` configuration: The primary way to set the number of fuzz runs for a project is in the foundry.toml file. The correct syntax is indeed to add a [fuzz] section and a runs key, like this:
  
    ```bash
    [fuzz]
    runs = 1000

    [invariant]
    # Run 512 different test sequences.
    runs = 512 

    # In each sequence, make up to 100 function calls.
    depth = 100 

    # Don't fail the entire test if one of the random calls reverts.
    fail_on_revert = false
    ```

* In Foundry fuzz testing, what mechanism allows developers to track state or count occurrences within a Handler contract across multiple function calls?

  1. What they are: Ghost variables are special state variables declared in your test contract (not the Handler) that are made accessible within the Handler contract. They are declared using the `ghost` keyword.

  2. How they work: The test runner "links" the ghost variable in the main test contract to the Handler. This allows the Handler to read and write to this variable, and its value persists across the multiple, random function calls within a single invariant test run.

  3. Primary Purpose: Their main use is to track state, count how many times certain functions were called, or accumulate data about the behavior of the system throughout a fuzzing sequence. This tracked data can then be used in the `invariant_` functions to assert that complex properties hold true.

    ```solidity
    contract MyInvariantTest is Test {
        MyContract implementation;
        Handler handler;

        // Declare a ghost variable to count how many times stake() was called.
        uint256 public ghost g_stakeCount;

        function setUp() public {
            implementation = new MyContract();
            handler = new Handler(implementation);
            targetContract(address(handler));
        }

        // The invariant checks if the total staked amount matches our tracked count.
        function invariant_stakeCountMatches() public view {
            uint256 totalStakes = implementation.totalStakes();
            assertEq(totalStakes, g_stakeCount);
        }
    }

    contract Handler is DSTest {
        MyContract contractInstance;
        
        // This state variable would be useless as it resets.
        // uint256 local_stake_count; 

        constructor(MyContract _contractInstance) {
            contractInstance = _contractInstance;
        }

        function stake(uint256 amount) public {
            // ... logic to call the real stake function ...
            
            // Update the ghost variable from the parent test contract.
            MyInvariantTest(address(this)).g_stakeCount++;
        }
    }
    ```

## Understanding Overcollateralization in DeFi Lending Protocols

The entire system revolves around two key participants: `Lenders (or Suppliers)` who provide assets to earn interest, and `Borrowers` who provide collateral to take out loans.

### Why Overcollateralization is Crucial in Decentralized Lending Protocols

Overcollateralization is a foundational concept in decentralized finance (DeFi) lending, serving as the primary mechanism to secure loans in a trustless environment. Unlike traditional finance, which relies on credit scores and legal agreements, DeFi protocols use smart contracts and crypto assets to manage lending and borrowing. Here’s a detailed look at why requiring borrowers to lock up collateral worth more than the loan value is essential.

* #### `Volatility of Collateral`
    Cryptocurrencies, which are often used as collateral (e.g., Ether, Bitcoin), are highly volatile. Their prices can fluctuate rapidly and significantly. If a loan were only 1:1 collateralized, even a small drop in the collateral's price could make the loan undercollateralized (i.e., the value of the collateral is less than the borrowed amount). This would introduce immediate risk to the lender or the protocol itself. Overcollateralization ensures that there is a cushion to absorb these price swings without jeopardizing the loan's solvency.

* #### `Liquidation Mechanism`
    When a loan becomes undercollateralized, the protocol needs a mechanism to ensure solvency. This mechanism is called liquidation. Liquidators, who are typically automated bots or other network participants, are incentivized to repay the undercollateralized debt. In return for repaying the debt, they receive a portion of the borrower's collateral, usually at a discount to the market price. This process ensures that the protocol can recover the loaned funds even if the borrower defaults. Without sufficient overcollateralization, the liquidation process would not be effective, as there might not be enough collateral value to cover the debt and incentivize liquidators.

    The primary function of a liquidation mechanism in a collateralized debt protocol is to maintain the protocol's solvency by allowing the removal of undercollateralized positions.

* #### `The Safety Buffer`
    The requirement for the collateral's value to significantly exceed the borrowed amount (e.g., a 150% or 200% collateralization ratio) acts as a safety buffer. This buffer is critical for several reasons:

    * **Price Drops**: The collateral can experience a substantial price drop before the loan reaches the liquidation threshold (e.g., a health factor of 1). This gives the borrower valuable time to take corrective action, such as adding more collateral to their position or repaying a portion of their loan to re-establish a healthy collateralization ratio.

    * **Slippage/Fees during Liquidation**: Liquidations are not frictionless. They involve transaction fees on the blockchain (gas fees) and potential price slippage when the seized collateral is sold on the open market, especially during times of high market volatility. The overcollateralization ensures that even after accounting for these costs, there is enough value in the collateral to fully cover the outstanding debt. It also guarantees that a sufficient incentive (the liquidation bonus) can be offered to liquidators to ensure they act promptly, thus maintaining the overall solvency of the protocol.

* #### `Maintaining Protocol Solvency`
    Ultimately, overcollateralization is about preserving the financial stability of the lending protocol. If loans were not adequately overcollateralized and a significant market downturn occurred, the protocol could be left with a large amount of unrecoverable debt. This "bad debt" would undermine the protocol's integrity, potentially causing a loss of confidence among its users and a decline in the value of its native governance token or associated stablecoin. By enforcing strict overcollateralization rules, protocols can safeguard themselves against systemic risk and ensure their long-term viability.

### The Role of the Health Factor

To provide users with a clear and immediate understanding of the risk associated with their borrowed positions, DeFi lending protocols often use a "Health Factor."

* #### `Health Factor as a Risk Indicator`
    The Health Factor is a single, consolidated metric designed to show how "healthy" or safe a user's borrowed position is. A health factor above 1 indicates a healthy, overcollateralized position. As the value of the collateral decreases or the amount of accrued interest on the debt increases, the health factor will decrease, signaling a rising risk of liquidation.

* #### `Minimum Threshold`
    Protocols establish a `MIN_HEALTH_FACTOR`, which is typically set to 1. If a user's health factor falls to or below this critical threshold, their position is no longer considered safe. It's worth noting that in the context of smart contracts written in Solidity, which does not handle floating-point numbers natively, this value is often represented as a large integer, such as `1e18` (1 followed by 18 zeros), to signify `1.0`.

* #### `Liquidation Trigger`
    Once the health factor drops below this minimum threshold of 1, the smart contract logic automatically flags the position as "liquidatable." This acts as a trigger, making the borrower's collateral available for seizure by other participants in the network.

* #### `The Liquidation Process`
    When a position is flagged for liquidation, "liquidators" are incentivized to step in. These can be anyone, but are often sophisticated bots monitoring the blockchain for such opportunities. A liquidator can repay a portion (or all) of the user's outstanding debt to the protocol. In return for clearing this debt, the liquidator is permitted to claim a proportional amount of the user's collateral, typically with an added bonus (e.g., 5-10% extra collateral). This liquidation bonus serves as the economic incentive that ensures the crucial role of liquidation is reliably performed, thereby removing bad debt from the protocol and maintaining its solvency.

### Calculating the Minimum Over-collateralization Ratio: An Example

Let's consider a practical example to understand how protocol constants translate into a required over-collateralization ratio.

If a protocol uses a `LIQUIDATION_THRESHOLD` constant set to `50` alongside a `LIQUIDATION_PRECISION` of `100`, what minimum over-collateralization ratio does this imply for a user's position to be considered safe (Health Factor >= 1)?

Here's the breakdown:

* **`LIQUIDATION_THRESHOLD` (50)**: This constant represents the maximum percentage of the collateral's value that the debt's value can reach before the position becomes eligible for liquidation.

* **`LIQUIDATION_PRECISION` (100)**: This is a scaling factor used to handle decimal values in an integer-only environment. It means that the `LIQUIDATION_THRESHOLD` (50) should be interpreted as $50 / 100 = 0.50$, or 50%.

So, a `LIQUIDATION_THRESHOLD` of 50 with a `LIQUIDATION_PRECISION` of 100 implies that your debt can be at most 50% of your collateral's value before liquidation is possible.

Let's apply this to the health factor and the concept of over-collateralization:

* **Health Factor Calculation (simplified)**: The Health Factor can be calculated as:
    $$ \text{Health Factor} = \frac{\text{Collateral Value} \times \text{Liquidation Threshold}}{\text{Borrowed Amount}} $$

    For a position to be at the brink of safety (Health Factor = 1), the following must be true:
    $$ \text{Collateral Value} \times \text{Liquidation Threshold} \geq \text{Borrowed Amount} $$

    Substituting our Liquidation Threshold of 0.50:
    $$ \text{Collateral Value} \times 0.50 \geq \text{Borrowed Amount} $$

    To find the required collateral value, we rearrange the formula:
    $$ \text{Collateral Value} \geq \frac{\text{Borrowed Amount}}{0.50} $$

    This simplifies to:
    $$ \text{Collateral Value} \geq \text{Borrowed Amount} \times 2 $$

* **Over-collateralization Ratio**:
    If the collateral's value must be at least twice the borrowed amount to be considered "safe" (i.e., at the liquidation threshold), this means for every $1 of debt, a user needs to provide $2 of collateral.

    Expressed as a percentage ratio:
    $$ \text{Ratio} = \frac{\text{Collateral Value}}{\text{Borrowed Amount}} \times 100\% $$
    $$ \text{Ratio} = \frac{2}{1} \times 100\% = 200\% $$

Therefore, a `LIQUIDATION_THRESHOLD` of 50 alongside a `LIQUIDATION_PRECISION` of 100 implies a **minimum over-collateralization ratio of 200%** for a user's position to be at the edge of safety (Health Factor = 1). To maintain a truly safe position with a Health Factor comfortably above 1, a user would need to provide collateral worth even more than 200% of their loan.

## When a smart contract needs to burn tokens held by a user to reduce their outstanding debt, what step is typically required *before* the contract can execute the burn operation?

* The user must have previously granted the smart contract an allowance to transfer the specified amount of tokens from their wallet.

This is a fundamental security principle of the ERC-20 token standard on which most DeFi protocols operate. A smart contract cannot arbitrarily take tokens from a user's wallet.

  1. Permission Grant (The `approve` function): For a protocol to use your tokens (e.g., to repay debt), you must first give it permission. You do this by calling the approve() function on the token's contract, specifying the protocol's contract address and the maximum amount of tokens it is allowed to manage on your behalf.

  2. Executing the Action (The `transferFrom` function): Once the allowance is granted, the protocol's smart contract can then call the transferFrom() function. This function moves the specified number of tokens (up to the allowance limit) from your wallet to itself or to a burn address (address(0)), effectively reducing your debt.

Without this prior approval (allowance), any attempt by the smart contract to move your tokens would be rejected by the token contract itself.

## Collateralized Debt Position (CDP)

In a Collateralized Debt Position (CDP) system, your deposited assets act as security for your loan.

* When you want to get some of that security deposit back, you "redeem" it.
* The `redeemCollateral` function facilitates this process. It allows you to specify an amount of collateral to withdraw.
* Critically, the function's logic will first calculate if your position will still be safely overcollateralized after the withdrawal. If withdrawing the requested amount would cause your loan's health factor to drop below the safe threshold, the transaction will fail to protect the protocol from risk.
