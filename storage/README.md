## function visibility specifiers

* public: This is the most permissive specifier. A public function can be called from anywhere: internally from within the contract itself, externally from other contracts, and by users making transactions.

* private: This is the most restrictive. A private function can only be called from other functions within the same contract where it is defined. It cannot be called by derived contracts or externally.

* external: An external function can only be called from outside the contract (i.e., from other contracts or via transactions). It cannot be called internally (e.g., this.myExternalFunction()).

* internal: An internal function can be called from within the defining contract and also from any contracts that inherit from it. It cannot be called externally.

## Notes

* `Storage variables` are meant to persist between function calls and are only declared at the contract level. Can't be used for new variables inside a function in Solidity.
* In Solidity, all storage locations are initialized to a default value, which is the byte-representation of zero. This concept applies to mappings as well.
* The `view^ keyword is a state mutability specifier in Solidity. It acts as a promise that the function will not alter the state of the blockchain.
