// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {ProgrammableDefensiveTokenTransfers} from "../src/ProgrammableDefensiveTokenTransfers.sol";

// sender
contract DeployProgrammableDefensiveTokenTransfersSender is Script {
    address private constant FUJI_ROUTER_ADDRESS = 0xF694E193200268f9a4868e4Aa017A0118C9a8177; // Avalanche Fuji router
    address private constant LINK_CONTRACT_ADDRESS = 0x0b9d5D9136855f6FEc3c0993feE6E9CE8a297846; // LINK contract address

    function run() external returns (ProgrammableDefensiveTokenTransfers) {
        vm.startBroadcast();

        ProgrammableDefensiveTokenTransfers programmableDefensiveTokenTransfers = new ProgrammableDefensiveTokenTransfers(FUJI_ROUTER_ADDRESS, LINK_CONTRACT_ADDRESS);

        vm.stopBroadcast();
        return programmableDefensiveTokenTransfers;
    }    
}
