// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import {TransferUSDC} from "../src/TransferUSDC.sol";

contract DeployTransferUSDC is Script {
    address private constant CCIP_ROUTER_ADDRESS = 0xF694E193200268f9a4868e4Aa017A0118C9a8177; 
    address private constant LINK_TOKEN_ADDRESS = 0x0b9d5D9136855f6FEc3c0993feE6E9CE8a297846;
    address private constant USDC_TOKEN_ADDRESS = 0x5425890298aed601595a70AB815c96711a31Bc65;

    function run() external returns (TransferUSDC) {
        vm.startBroadcast();

        TransferUSDC transferUSDC = new TransferUSDC(CCIP_ROUTER_ADDRESS, LINK_TOKEN_ADDRESS, USDC_TOKEN_ADDRESS);

        vm.stopBroadcast();
        return transferUSDC;
    }   
}
