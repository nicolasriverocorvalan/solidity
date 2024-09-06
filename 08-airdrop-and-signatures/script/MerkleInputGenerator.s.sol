// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {console} from "forge-std/console.sol";

contract MerkleInputGenerator is Script {
    uint256 private constant AMOUNT = 25 * 1e18; // amount to be claimed
    string[] types = new string[](2); // types of the values, address and uint
    uint256 count; // the number of allowlist addresses
    string[] allowlist = new string[](4);
    string private constant INPUT_PATH = "/script/merkle-scripts/input.json";
    
    function run() public {
        types[0] = "address";
        types[1] = "uint";
        allowlist[0] = "0x64Dd9D94818A2CA2e95c31B084aeF0CC92e86dA2";
        allowlist[1] = "0xfd611697b1225bbDe2C47b8615E9f1a1AeBcdbF0";
        allowlist[2] = "0x6B273F2D4fbB2E41C27ccB55144dBEffd30C583B";
        allowlist[3] = "0xaBC990615A2C3d91442fc3Dc26881E61C2659c0c";
        count = allowlist.length;
        string memory input = _createJSON();
        vm.writeFile(string.concat(vm.projectRoot(), INPUT_PATH), input);

        console.log("Output created at %s", INPUT_PATH);
    }

    function _createJSON() internal view returns (string memory) {
        string memory countString = vm.toString(count); // convert count to string
        string memory amountString = vm.toString(AMOUNT); // convert amount to string
        string memory json = string.concat('{ "types": ["address", "uint"], "count":', countString, ',"values": {');
        for (uint256 i = 0; i < allowlist.length; i++) {
            if (i == allowlist.length - 1) {
                json = string.concat(json, '"', vm.toString(i), '"', ': { "0":', '"',allowlist[i],'"',', "1":', '"',amountString,'"', ' }');
            } else {
            json = string.concat(json, '"', vm.toString(i), '"', ': { "0":', '"',allowlist[i],'"',', "1":', '"',amountString,'"', ' },');
            }
        }
        json = string.concat(json, '} }');
        
        return json;
    }
}