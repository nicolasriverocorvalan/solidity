// SPDX-License-Identifier:  MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {XNFT} from "../src/XNFT.sol";
import {CCIPLocalSimulatorFork, Register} from "@chainlink/local/src/ccip/CCIPLocalSimulatorFork.sol";
import {EncodeExtraArgs} from "./utils/EncodeExtraArgs.sol";

contract XNFTTest is Test {
    CCIPLocalSimulatorFork public ccipLocalSimulatorFork;
    uint256 ethSepoliaFork;
    uint256 arbSepoliaFork;
    Register.NetworkDetails ethSepoliaNetworkDetails;
    Register.NetworkDetails arbSepoliaNetworkDetails;

    address alice;
    address bob;

    XNFT public ethSepoliaXNFT;
    XNFT public arbSepoliaXNFT;

    EncodeExtraArgs public encodeExtraArgs;

    function setUp() public {
        alice = makeAddr("alice");
        bob = makeAddr("bob");

        string memory SEPOLIA_RPC_URL = vm.envString("SEPOLIA_RPC_URL");
        string memory ARBITRUM_RPC_URL = vm.envString("ARBITRUM_RPC_URL");
        ethSepoliaFork = vm.createSelectFork(SEPOLIA_RPC_URL);
        arbSepoliaFork = vm.createFork(ARBITRUM_RPC_URL);

        ccipLocalSimulatorFork = new CCIPLocalSimulatorFork();
        vm.makePersistent(address(ccipLocalSimulatorFork));

        // deploy XNFT.sol to Ethereum Sepolia
        assertEq(vm.activeFork(), ethSepoliaFork);

        ethSepoliaNetworkDetails = ccipLocalSimulatorFork.getNetworkDetails(block.chainid); // we are currently on Ethereum Sepolia Fork
        assertEq(
            ethSepoliaNetworkDetails.chainSelector,
            16015286601757825753,
            "Sanity check: Ethereum Sepolia chain selector should be 16015286601757825753"
        );

        ethSepoliaXNFT = new XNFT(
            ethSepoliaNetworkDetails.routerAddress,
            ethSepoliaNetworkDetails.linkAddress,
            ethSepoliaNetworkDetails.chainSelector
        );

        // deploy XNFT.sol to Arbitrum Sepolia
        vm.selectFork(arbSepoliaFork);
        assertEq(vm.activeFork(), arbSepoliaFork);

        arbSepoliaNetworkDetails = ccipLocalSimulatorFork.getNetworkDetails(block.chainid); // we are currently on Arbitrum Sepolia Fork
        assertEq(
            arbSepoliaNetworkDetails.chainSelector,
            3478487238524512106,
            "Sanity check: Arbitrum Sepolia chain selector should be 421614"
        );

        arbSepoliaXNFT = new XNFT(
            arbSepoliaNetworkDetails.routerAddress,
            arbSepoliaNetworkDetails.linkAddress,
            arbSepoliaNetworkDetails.chainSelector
        );
    }

    function testShouldMintNftOnArbitrumSepoliaAndTransferItToEthereumSepolia() public {
        // on Ethereum Sepolia, call enableChain function
        vm.selectFork(ethSepoliaFork);
        assertEq(vm.activeFork(), ethSepoliaFork);

        encodeExtraArgs = new EncodeExtraArgs();

        uint256 gasLimit = 200_000;
        bytes memory extraArgs = encodeExtraArgs.encode(gasLimit);
        assertEq(extraArgs, hex"97a657c90000000000000000000000000000000000000000000000000000000000030d40");

        ethSepoliaXNFT.enableChain(arbSepoliaNetworkDetails.chainSelector, address(arbSepoliaXNFT), extraArgs);

        // on Arbitrum Sepolia, call enableChain function
        vm.selectFork(arbSepoliaFork);
        assertEq(vm.activeFork(), arbSepoliaFork);

        arbSepoliaXNFT.enableChain(ethSepoliaNetworkDetails.chainSelector, address(ethSepoliaXNFT), extraArgs);

        // on Arbitrum Sepolia, fund XNFT.sol with 3 LINK
        assertEq(vm.activeFork(), arbSepoliaFork);

        ccipLocalSimulatorFork.requestLinkFromFaucet(address(arbSepoliaXNFT), 3 ether);

        // on Arbitrum Sepolia, mint new xNFT
        assertEq(vm.activeFork(), arbSepoliaFork);

        vm.startPrank(alice);

        arbSepoliaXNFT.mint();
        uint256 tokenId = 0;
        assertEq(arbSepoliaXNFT.balanceOf(alice), 1);
        assertEq(arbSepoliaXNFT.ownerOf(tokenId), alice);

        // on Arbitrum Sepolia, crossTransferFrom xNFT
        arbSepoliaXNFT.crossChainTransferFrom(
            address(alice), address(bob), tokenId, ethSepoliaNetworkDetails.chainSelector, XNFT.PayFeesIn.LINK
        );

        vm.stopPrank();

        assertEq(arbSepoliaXNFT.balanceOf(alice), 0);

        // on Ethereum Sepolia, check if xNFT was succesfully transferred
        ccipLocalSimulatorFork.switchChainAndRouteMessage(ethSepoliaFork); // IMPORTANT, THIS LINE REPLACES CHAINLINK CCIP DONs
        assertEq(vm.activeFork(), ethSepoliaFork);

        assertEq(ethSepoliaXNFT.balanceOf(bob), 1);
        assertEq(ethSepoliaXNFT.ownerOf(tokenId), bob);
    }    
}
