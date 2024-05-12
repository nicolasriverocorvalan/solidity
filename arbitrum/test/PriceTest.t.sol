// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {PriceFeed} from "../src/PriceFeed.sol";
import {DeployPriceFeed} from "../script/DeployPriceFeed.s.sol";

contract PriceTest is Test {
    PriceFeed priceFeed;
    
    function setUp() external {
        DeployPriceFeed deployPriceFeed = new DeployPriceFeed();
        priceFeed = deployPriceFeed.run();
    }

    function testGetPrice() public view {
        console.log("Price: %s", priceFeed.getPrice());
    }    
}
