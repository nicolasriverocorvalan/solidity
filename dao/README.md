# Decentralized Autonomous Organizations (DAOs) and Governance

* Any group that is governed by a transparent set of rules found on a blockchain or smart contract.

## Voting Mechanism

### 1. Token-Based Voting: The Plutocratic Paradigm

The most common and straightforward voting mechanism in the DAO ecosystem is token-based voting. In this model, influence is directly proportional to the number of governance tokens a member holds.

* **How it Works:** The principle is simple: **one token, one vote**. When a proposal is put forth, the voting power of each participant is weighted by the amount of the DAO's native token they possess. For a proposal to pass, it typically needs to achieve a predetermined quorum (a minimum percentage of total tokens participating in the vote) and a majority of the votes cast.

* **Advantages:**
    * **Simplicity:** It's easy to understand and implement on a blockchain.
    * **Clear Stake:** It directly ties voting power to the financial stake a member has in the organization's success. The more tokens one holds, the more they stand to gain or lose from the DAO's decisions.

* **Disadvantages:**
    * **Plutocracy:** This model can lead to a system where wealth equals power. A small number of **"whales"** (individuals or entities holding a large number of tokens) can dominate the decision-making process, potentially overriding the desires of the broader community.
    * **Voter Apathy:** Small token holders may feel their vote is insignificant and choose not to participate, further centralizing power among the largest stakeholders.

---

### 2. "Skin in the Game" Voting: Aligning Long-Term Interests

The concept of "skin in the game" asserts that those with a vested interest in the long-term health and success of the DAO should have a greater say in its governance. While simple token-based voting is a form of this, more sophisticated mechanisms have been developed to better capture nuanced commitment and discourage short-term speculation.

#### Delegated Voting (Liquid Democracy)
This model is a hybrid of direct and representative democracy. Token holders can choose to either vote directly on proposals or delegate their voting power to another member or a dedicated "delegate" whom they trust to make informed decisions on their behalf. This delegation is "liquid" because the token holder can reclaim their voting power at any time. This system values the "skin in the game" of reputation and expertise, allowing for more efficient decision-making without completely sacrificing individual sovereignty.

#### Conviction Voting
This mechanism introduces the element of time to the voting process. Instead of a simple "yes" or "no" vote, members "stake" their tokens on proposals they support. The longer a member's tokens remain staked on a particular proposal, the more **"conviction"** their vote accumulates. This means that proposals need sustained, long-term support to pass, making it more difficult for wealthy actors to quickly push through contentious initiatives. This model rewards the "skin in the game" of unwavering belief and long-term commitment.

---

### 3. Proof of Personhood or Participation: From Capital to Contribution

In a direct challenge to the capital-centric nature of token-based voting, this category of mechanisms seeks to anchor voting power in human identity and active contribution rather than wealth. The primary goal is to mitigate **Sybil attacks**, where a single user can create multiple wallets to amass greater voting power.

#### Proof of Personhood (PoP)
The aim of Proof of Personhood is to achieve a **"one human, one vote"** system. It employs various methods to verify that a digital wallet is controlled by a unique individual. Some common approaches include:

* **Social Verification:** Services like BrightID require users to connect with others in a social graph or participate in video calls to verify their uniqueness.
* **Biometric Data:** Projects like Worldcoin use hardware to scan a user's iris to generate a unique, anonymous identifier.
* **Reverse Turing Tests:** Some systems require users to solve complex puzzles that are easy for humans but difficult for bots.

By ensuring that each participant is a unique individual, Proof of Personhood creates a more egalitarian and democratic governance structure.

#### Proof of Participation
This model rewards active engagement and meaningful contributions with governance power. Instead of treating all token holders equally, it gives more weight to those who have demonstrated a commitment to the DAO through their actions. This can take several forms:

* **Reputation Scores:** Members can earn non-transferable reputation tokens or points for completing tasks, participating in working groups, or making valuable contributions to discussions.
* **Proof of Attendance Protocol (POAP):** DAOs can issue unique NFT badges (POAPs) to members who attend community calls, town halls, or specific events. These POAPs can then be used to grant voting rights on relevant topics, ensuring that those who are most engaged have a say.

By valuing contribution over capital, Proof of Participation incentivizes a more active and informed member base, ensuring that those with deep knowledge and dedication to the DAO's mission have a significant voice in its evolution.

## Implementation

* On chain voting: for example Compound, cost GAS.
* Off chain voting: replay side transactions in a single transaction to reduce the voting cost, for example send a transaction signed + IPFS + oracle (centralized).

## Notes 

Exercise requirements:

* We are going to have a contract controlled by DAO.
* Every transaction that the DAO wants to send has to be voted on.
* We will use ERC20 tokens for voting (not recommended model).

## Cheat sheet
* `forge test --mt testCantUpdateBoxWithoutGovernance`
* `forge test --mt testGovernanceUpdatesBox -vv`
