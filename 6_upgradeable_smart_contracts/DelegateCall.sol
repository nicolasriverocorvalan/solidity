contract B {
    // NOTE: storage layout must be the same as contract A
    uint256 public num;
    address public sender;
    uint256 public value;

    function setVars(uint256 _num) public payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
}

/*
Our Contract B has three storage variables (num, sender and value), and one function setVars 
that updates our num value. In Ethereum, contract storage variables are stored in a specific 
storage data structure that's indexed starting from zero. This means that num is at index zero, 
sender at index one and value at index two.
*/

contract A {
    uint256 public num;
    address public sender;
    uint256 public value;

    function setVars(address _contract, uint256 _num) public payable {
        // A's storage is set, B is not modified.
        // (bool success, bytes memory data) = _contract.delegatecall(
        (bool success, ) = _contract.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
        if (!success) {
            revert("delegatecall failed");
        }
    }
}

/*
If contract A called setVars on contract B, it would only update contract B's num storage. 
However, by using delegate call, it says "call setVars function and then pass _num as an 
input parameter but call it in our contract (A). In essence, it 'borrows' the setVars function 
and uses it in its own context. 
*/
