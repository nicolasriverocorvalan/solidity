// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {IAccount} from "../../lib/account-abstraction/contracts/interfaces/IAccount.sol";
import {PackedUserOperation} from "../../lib/account-abstraction/contracts/interfaces/PackedUserOperation.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol"; // function toEthSignedMessageHash
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol"; // function recover
import {SIG_VALIDATION_SUCCESS, SIG_VALIDATION_FAILED} from "../../lib/account-abstraction/contracts/core/Helpers.sol";
import {IEntryPoint} from "../../lib/account-abstraction/contracts/interfaces/IEntryPoint.sol";

// Entry point calls this contract
contract MinimalAccount is IAccount, Ownable{
    error MinimalAccount__NotFromEntryPoint();
    error MinimalAccount__NotFromEntryPointOrOwner();
    error MinimalAccount__ExecutionFailed(bytes);

    IEntryPoint private immutable i_entryPoint;

    modifier requireFromEntryPoint(){
        if(msg.sender != address(i_entryPoint)){
            revert MinimalAccount__NotFromEntryPoint();
        }
        _;
    }

    modifier requireFromEntryPointOrOwner(){
        if(msg.sender != address(i_entryPoint) && msg.sender != owner()){
            revert MinimalAccount__NotFromEntryPointOrOwner();
        }
        _;
    }

    constructor( address entryPoint) Ownable(msg.sender) { 
        i_entryPoint = IEntryPoint(entryPoint);
    }

    receive() external payable {}

    function execute(address to, uint256 value, bytes calldata data) external requireFromEntryPointOrOwner {
        (bool success, bytes memory result) = to.call{value: value}(data);
        if(!success){
            revert MinimalAccount__ExecutionFailed(result);
        }
        require(success, "MinimalAccount: execution failed");
    }

    function validateUserOp(PackedUserOperation calldata userOp,bytes32 userOpHash,uint256 missingAccountFunds) external requireFromEntryPoint returns (uint256 validationData){   
        validationData = validateSignature(userOp,userOpHash);

        // payback money to the entry point
        payPreFund(missingAccountFunds);
    }

    function validateSignature(PackedUserOperation calldata userOp,bytes32 userOpHash) internal view returns (uint256 validationData){
        // Validate the signature
        // userOpHash -> EIP-191 version of the signed hash
        bytes32 ethSignedMessageHash = MessageHashUtils.toEthSignedMessageHash(userOpHash);
        address signer = ECDSA.recover(ethSignedMessageHash, userOp.signature); // returns the address that signed the message

        if(signer != owner()){
            return SIG_VALIDATION_FAILED; //1
        }
        return SIG_VALIDATION_SUCCESS; //0
    }

    function payPreFund(uint256 missingAccountFunds) internal{
        // Payback the money to the entry point
        if(missingAccountFunds > 0){
            (bool success,) = payable(msg.sender).call{value: missingAccountFunds, gas: type(uint256).max}("");
            (success);
        }
    }

    function getEntryPoint() external view returns (address){
        return address(i_entryPoint);
    }
}
