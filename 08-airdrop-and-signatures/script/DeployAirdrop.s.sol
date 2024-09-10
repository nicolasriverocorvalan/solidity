// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Script} from "forge-std/script.sol";
import {Airdrop} from "../src/Airdrop.sol";
import {ElBarto} from "../src/ElBarto.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DeployAirdrop is Script {
    bytes32 private s_merkleRoot = 0xa3380204c782abb3523e8e685d8c4f3425c3f721593cea2e22dd5bce518de0ba;
    uint256 private s_amountToMint = 4 * 25 * 1e18;

    function run() external returns (Airdrop, ElBarto) {
        vm.startBroadcast();
        ElBarto token = new ElBarto();
        Airdrop airdrop = new Airdrop(s_merkleRoot, IERC20(token));
        token.mint(token.owner(), s_amountToMint);
        token.transfer(address(airdrop), s_amountToMint);
        vm.stopBroadcast();

        return (airdrop, token);
    }

}