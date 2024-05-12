// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {PriceFeed} from "../src/PriceFeed.sol";

contract DeployPriceFeed is Script {
    function run() external returns (PriceFeed) {
        vm.startBroadcast();
        PriceFeed priceFeed = new PriceFeed();
        vm.stopBroadcast();
        return (priceFeed);
    }
}
