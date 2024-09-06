// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {IERC20, SafeERC20} from "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import {MerkleProof} from "openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol";

contract MerkleAirdrop {
    // some list of addresses
    // allow someone in the list to claim tokens

    using SafeERC20 for IERC20;

    error MerkleAirdrop__InvalidProof();
    error MerkleAirdrop__AlreadyClaimed();

    address[] claimers;
    bytes32 private immutable i_merkleRoot;
    IERC20 private immutable i_airdropToken;
    mapping(address claimer => bool claimed) private s_hasClaimed;

    event Claimed(address indexed account, uint256 amount);

    constructor(bytes32 _merkleRoot, IERC20 _airdropToken){
        i_merkleRoot = _merkleRoot;
        i_airdropToken = _airdropToken;
    }

    function claim(address _account, uint256 _amount, bytes32[] calldata _merkleProof) external{
        if(s_hasClaimed[_account]){
            revert MerkleAirdrop__AlreadyClaimed();
        }

        // calculate the hash (leaf node), using the account and amount
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(_account, _amount))));
        if(!MerkleProof.verify(_merkleProof, i_merkleRoot, leaf)){
            revert MerkleAirdrop__InvalidProof();
        }

        s_hasClaimed[_account] = true;
        emit Claimed(_account, _amount);

        i_airdropToken.safeTransfer(_account, _amount);
    }

    function getMerkleRoot() external view returns(bytes32){
        return i_merkleRoot;
    }

    function getAirDropToken() external view returns(IERC20){
        return i_airdropToken;
    }
    
    
}
