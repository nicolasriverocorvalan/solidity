// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256; // using our own Library, msg.value is uint256

    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;
    address[] public funders;

    uint256 public constant MINIMUM_USD = 5e18; // 5 * (10 ** 18) 'OR' 5 * 1d18
    
    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        // allow users to send $
        // Have a minimun $ sent
        // msg.value = number of WEI sent with the message

        // revert = undo any action that have been done ,and send the remaining gas back
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Not enough ETH");

        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }
    
    // modifier = keyword to add in the funtion declaration
    modifier onlyOwner { 
        // require(msg.sender == i_owner);
        if (msg.sender != i_owner) revert NotOwner();
        _; // execute function content
    }
    
    function withdraw() public onlyOwner {
        for (uint256 funderIndex=0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        
        // reset founders array
        funders = new address[](0); 
        
        //withdraw the funds
        // 1- transfer
        // payable(msg.sender).transfer(address(this).balance); // auto revert
        
        // 2- send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed"); // needed for revert

        // 3- call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }
    // Explainer from: https://solidity-by-example.org/fallback/
    // Ether is sent to contract
    //      is msg.data empty?
    //          /   \ 
    //         yes  no
    //         /     \
    //    receive()?  fallback() 
    //     /   \ 
    //   yes   no
    //  /        \
    //receive()  fallback()

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }

}
