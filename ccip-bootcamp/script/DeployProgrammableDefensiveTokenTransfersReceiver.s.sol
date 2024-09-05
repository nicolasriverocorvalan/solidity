// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {ProgrammableDefensiveTokenTransfers} from "../src/ProgrammableDefensiveTokenTransfers.sol";

// receiver
contract DeployProgrammableDefensiveTokenTransfersReceiver is Script {
    address private constant SEPOLIA_ROUTER_ADDRESS = 0x0BF3dE8c5D3e8A2B34D2BEeB17ABfCeBaf363A59; // Eth Sepolia router
    address private constant LINK_CONTRACT_ADDRESS = 0x779877A7B0D9E8603169DdbD7836e478b4624789; // LINK contract address

    function run() external returns (ProgrammableDefensiveTokenTransfers) {
        vm.startBroadcast();

        ProgrammableDefensiveTokenTransfers programmableDefensiveTokenTransfers = new ProgrammableDefensiveTokenTransfers(SEPOLIA_ROUTER_ADDRESS, LINK_CONTRACT_ADDRESS);

        vm.stopBroadcast();
        return programmableDefensiveTokenTransfers;
    }    
}
