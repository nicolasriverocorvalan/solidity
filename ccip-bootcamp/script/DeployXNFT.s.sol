// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import {XNFT} from "../src/XNFT.sol";

contract DeployXNFT is Script {
    function run() public {
        address ccipRouterAddress = vm.envAddress("CCIP_ROUTER_ADDRESS");
        address linkTokenAddress = vm.envAddress("LINK_TOKEN_ADDRESS");
        uint64 chainSelector = uint64(vm.envUint("CHAIN_SELECTOR"));
        string memory networkName = vm.envString("NETWORK_NAME");

        vm.startBroadcast();
        
        _deployToNetwork(
            ccipRouterAddress,
            linkTokenAddress,
            chainSelector,
            networkName
        );

        vm.stopBroadcast();
    }

    function _deployToNetwork(
        address ccipRouterAddress,
        address linkTokenAddress,
        uint64 chainSelector,
        string memory networkName
    ) internal {
        XNFT xNft = new XNFT(
            ccipRouterAddress,
            linkTokenAddress,
            chainSelector
        );

        console.log(
            string(abi.encodePacked("XNFT deployed to ", networkName, " at ")),
            address(xNft)
        );
    }
}
