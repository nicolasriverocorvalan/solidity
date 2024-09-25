// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {IERC20, SafeERC20} from "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import {MerkleProof} from "openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol";
import {EIP712} from "openzeppelin-contracts/contracts/utils/cryptography/EIP712.sol";
import {ECDSA} from "openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";

contract Airdrop is EIP712{
    using SafeERC20 for IERC20;

    error MerkleAirdrop__InvalidProof();
    error MerkleAirdrop__AlreadyClaimed();
    error MerkleAirdrop__InvalidSignature();

    address[] claimers;
    bytes32 private immutable i_merkleRoot;
    IERC20 private immutable i_airdropToken;
    mapping(address claimer => bool claimed) private s_hasClaimed;
    bytes32 private constant MESSAGE_TYPEHASH = keccak256("AirdropClaim(address account, uint256 amount)");

    struct AirdropClaim{
        address account;
        uint256 amount;
    }

    event Claimed(address indexed account, uint256 amount);

    constructor(bytes32 _merkleRoot, IERC20 _airdropToken) EIP712("Airdrop", "1"){
        i_merkleRoot = _merkleRoot;
        i_airdropToken = _airdropToken;
    }

    function claim(address _account, uint256 _amount, bytes32[] calldata _merkleProof, uint8 _v, bytes32 _r, bytes32 _s) external{
        if(s_hasClaimed[_account]){
            revert MerkleAirdrop__AlreadyClaimed();
        }

        // check the signature
        if(_isValidSignature(_account, getDigest(_account, _amount), _v, _r, _s)){
            revert MerkleAirdrop__InvalidSignature();
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

    // return the hash of the fully encoded EIP712 message
    function getDigest(address _account, uint256 _amount) public view returns(bytes32){
        return _hashTypedDataV4(
            keccak256(abi.encode(MESSAGE_TYPEHASH, AirdropClaim({account: _account,amount: _amount})))
        );
    }

    function _isValidSignature(address _account, bytes32 _digest, uint8 _v, bytes32 _r, bytes32 _s) internal pure returns(bool){
        (address actualSigner, ,) = ECDSA.tryRecover(_digest, _v, _r, _s);
        return actualSigner == _account;
    }

    function getMerkleRoot() external view returns(bytes32){
        return i_merkleRoot;
    }

    function getAirDropToken() external view returns(IERC20){
        return i_airdropToken;
    }
}
