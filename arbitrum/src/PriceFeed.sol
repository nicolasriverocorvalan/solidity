// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceFeed {
    // https://docs.chain.link/data-feeds/price-feeds/addresses
    // Sepolia ETH / USD Address = 0xd30e2101a97dcbAeBCBC04F14C3f624E67A35165
    
    function getPrice() external view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xd30e2101a97dcbAeBCBC04F14C3f624E67A35165);
        (, int256 price, , , ) = priceFeed.latestRoundData();
        
        // ETH/USD rate in 18 digit, price 8 decimals
        return uint256(price * 1e10);
    }
}
