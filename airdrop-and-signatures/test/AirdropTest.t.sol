// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test, console} from "forge-std/test.sol";
import {Airdrop} from "../src/Airdrop.sol";
import {ElBarto} from "../src/ElBarto.sol";
import {DeployAirdrop} from "../script/DeployAirdrop.s.sol";

contract AirdropTest is Test {
    Airdrop public airdrop;
    ElBarto public token;
    address public userAccount;
    uint256 public userPrivKey;

    bytes32 public ROOT=0xa3380204c782abb3523e8e685d8c4f3425c3f721593cea2e22dd5bce518de0ba;
    uint256 public AMOUNT= 25 * 1e18;
    uint256 public AMOUNT_TO_MINT= AMOUNT * 4;
    bytes32[] public PROOF = [ 
        bytes32(0x6ad3d9af63cee23822cc4fbdf3e292fb27dc2ac8b9cdc77261d549b1ff786104),
        bytes32(0x9eaa84cffafb90e2a48c078df539e822cdbcca6ae26f695050e763febd8509de)
    ];

    function setUp() public {
        token = new ElBarto();
        token.mint(token.owner(), AMOUNT_TO_MINT);
        airdrop = new Airdrop(ROOT,token);
        token.transfer(address(airdrop), AMOUNT_TO_MINT);
        (userAccount, userPrivKey) = makeAddrAndKey("user");
        console.log("User address: ", userAccount); //user address obtained: 0x6CA6d1e2D5347Bfab1d91e883F1915560e09129D
    }

    function testCanClaim() public {
        uint256 startingBalance = token.balanceOf(userAccount);

        vm.prank(userAccount);
        airdrop.claim(userAccount, AMOUNT, PROOF);

        uint256 endingBalance = token.balanceOf(userAccount);
        console.log("Starting balance: %d, Ending balance: %d", startingBalance, endingBalance);
        assertEq(endingBalance - startingBalance, AMOUNT);
    }
}