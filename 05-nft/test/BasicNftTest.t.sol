// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployBasicNft} from "../script/DeployBasicNft.s.sol";
import {BasicNft} from "../src/BasicNft.sol";

contract BasicNftTest is Test {
    DeployBasicNft public deployer;
    BasicNft public basicNft;
    address public USER = makeAddr("user");
    string public constant PUG = "https://ipfs.io/ipfs/QmSsYRx3LpDAb1GZQm7zZ1AuHZjfbPkD6J7s9r41xu1mf8";

    function setUp() public{
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testNameIsCorrect() public view {
        string memory expected = "Elbarto";
        string memory actualName = basicNft.name();

        assertEq(keccak256(bytes(actualName)), keccak256(bytes(expected)));
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(USER);
        basicNft.mintNft(PUG);

        assert(basicNft.balanceOf(USER) == 1);
        assert(keccak256(bytes(PUG)) == keccak256(bytes(basicNft.tokenURI(0))));
    }
}
