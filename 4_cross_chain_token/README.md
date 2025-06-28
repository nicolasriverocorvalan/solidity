## Notes

* `Standard ERC20 Token`: A standard ERC20 token, like UNI or LINK, has a total supply that only changes through explicit minting (creating new tokens) or burning (destroying existing tokens) events. Your personal balance of a standard token only changes when you actively send or receive it in a transaction. The number of tokens you hold is static unless you transact.

* `Rebase Token`: A rebase token (also called an elastic supply token) is designed to have its total supply algorithmically adjusted at regular intervals. This is called a "rebase." When a rebase occurs, the token balance in every single holder's wallet changes simultaneously without any transaction taking place.

* How might a smart contract determine a user's current balance for a digital asset designed to automatically incorporate accrued value by adjusting supply over time? By dynamically calculating the balance based on the stored principal balance and the elapsed time (or conditions like price) since the last update.

    1. Store the Share, Not the Balance: The contract doesn't store your exact, ever-changing token balance. Instead, it stores your proportional share of the total supply or underlying asset pool. This value only changes when you send or receive tokens.
    2. Calculate on Demand: When a user's balance is requested (e.g., through a balanceOf() call), the contract performs a dynamic calculation in real-time

* `Total balance`` includes recently accrued value not yet explicitly added to the stored balance, while principal balance` reflects the amount previously recorded via mint or burn operations.

    `Total Balance = Principal Balance ("last recorded" balance) + Interest Accrued Since Last Interaction`

* `rebasing`: The mechanism where token balances automatically adjust based on a predefined rate or logic.

* `AccessControl` pattern: It allows defining multiple distinct roles and assigning them to different accounts for granular permissions.

* In the context of `AccessControl`, how are unique identifiers for different roles commonly created? By computing the `keccak256` hash of a descriptive string representing the role name.

```solidity
contract MyToken is ERC20, AccessControl {
    // Define the unique identifier for the MINTER_ROLE
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    constructor() ERC20("MyToken", "MTK") {
        // Grant the contract deployer the default admin role
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        // Grant the contract deployer the minter role as well
        _grantRole(MINTER_ROLE, msg.sender);
    }

    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }
}
```

* `vm.warp(uint256 newTimestamp)`
  - Purpose: This is the most direct and common cheatcode for testing time-dependent logic. It sets block.timestamp to the exact newTimestamp you provide.

    - Use Case: If you want to check the state of your contract at a specific point in the future (e.g., exactly one year from now to check annual interest), you would calculate that future timestamp and use vm.warp() to jump directly to it.

    ```solidity
    // Go to a specific time in the future
    uint256 oneYearFromNow = block.timestamp + 365 days;
    vm.warp(oneYearFromNow);

    // Now, any logic that reads `block.timestamp` will see `oneYearFromNow`.
    myContract.accrueInterest();
    ```

* `assertApproxEqAbs(value1, value2, tolerance)` is an assertion cheatcode used to verify that two numbers are almost equal, allowing for a small, acceptable difference between them. The "Abs" stands for Absolute Tolerance.

* `vm.expectRevert(bytes4 selector)`:

    - Purpose: This cheatcode asserts that the revert data is exactly the 4-byte selector and nothing else.
    - Use Case: It should be used when a function reverts with a custom error that has no arguments, like error `Unauthorized()`;. In this case, the entire revertdata is just the 4-byte selector.

* `vm.expectPartialRevert(bytes4 selector)`:

    - Purpose: This cheatcode asserts that the revert data begins with the specified 4-byte selector but ignores any data that follows.
    - Use Case: This is the correct tool for when a function reverts with a custom error that has arguments, like `AccessControlUnauthorizedAccount(address account, bytes32 role)`. It allows you to verify the correct error type was triggered without needing to match the specific account and role values.

* The `CCT Standard` is a standard built using `CCIP`, offering developers tools and interfaces to simplify cross-chain token creation.

    - `Chainlink Cross-Chain Interoperability Protocol (CCIP)`: This is the foundational, underlying protocol that provides a secure way to send messages and transfer tokens between different blockchains. It is the core infrastructure for cross-chain communication.

    - `Cross-Chain Token (CCT) Standard`: This is a higher-level standard that leverages the power of CCIP. It provides developers with pre-audited smart contracts and a simplified framework (including a "Token Manager" interface) to make new or existing ERC-20 tokens cross-chain compatible. Essentially, CCT is a user-friendly way to "plug into" CCIP for the specific purpose of token transfers.

* `Cross-chain messaging` is the foundational technology that enables smart contracts on one blockchain to communicate and interact with smart contracts on another. This communication isn't limited to just token transfers; it can be any arbitrary data, such as function calls, instructions, or proofs of state. Token bridging is one of the most common applications built on top of this fundamental messaging layer.
