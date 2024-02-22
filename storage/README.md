# Notes

## GAS - Ethereum Improvement Proposals (EIP) 1559

* Transaction Fee: Amount paid to the block producer for processing the transaction.
  - Gas used * Gas Price   

* Gas Price: Cost per unit of gas specified for the transaction, in Ether and Gwei. The higher the gas price the higher chance of getting included in a block.
  - Base fee: the minimun *gas price* you need to set to include your transaction. Ends up getting burnt.
  - Max fee: refers to the maximum gas fee that we are willing to pay for the transaction.
  - Max priority fee: the max gas fee that we are willing to pay plus the max tip tha we are willing to give to validators.
* Transaction fee - burnt fee = how much money went to validators.
