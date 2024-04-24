// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol"
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol"
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol"

contract BoxV1 is UUPSUpgradeable, Initializable, OwnableUpgradeable {
    uint256 internal number;

    // explcit constructor added just for training purposes
    // @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {
        // use __ as a convention to express initializers
        __Ownable_init(); // sets owner = msg.sender
        __UUPSUpgradeable_init();
    }

    function getNumber() public view returns (uint256) {
        return number;
    }

    function version() external pure returns (uint256) {
        return 1;
    }

    function _authorizeUpgrade(address newImplementation) internal override {}
}
