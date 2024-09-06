// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {console} from "forge-std/console.sol";
import {Merkle} from "murky/src/Merkle.sol";
import {ScriptHelper} from "murky/script/common/ScriptHelper.sol";


contract GenerateMerkle is Script, ScriptHelper {
    // enables json cheatcodes for string manipulation
    using stdJson for string;

    string private inputPath = "/script/merkle-scripts/input.json";
    string private outputPath = "/script/merkle-scripts/output.json";

    Merkle private m = new Merkle(); // Merkle proof generator

    string private elements = vm.readFile(string.concat(vm.projectRoot(), inputPath));
    string[] private types = elements.readStringArray(".types");
    uint256 private count = elements.readUint(".count");

    string[] private inputs = new string[](count);
    string[] private outputs = new string[](count);
    bytes32[] private leafs = new bytes32[](count);  

    string private output;

    function getValuesByIndex(uint256 i, uint256 j) internal pure returns (string memory) {
        return string.concat(".values.", vm.toString(i), ".", vm.toString(j));
    } 

    function generateOutputFile(string memory _inputs, string memory _proof, string memory _root, string memory _leaf)
        internal
        pure
        returns (string memory)
    {
        string memory result = string.concat(
            "{",
            "\"inputs\":",
            _inputs,
            ",",
            "\"proof\":",
            _proof,
            ",",
            "\"root\":\"",
            _root,
            "\",",
            "\"leaf\":\"",
            _leaf,
            "\"",
            "}"
        );

        return result;
    }

    /// read the input file, generate the Merkle proof, and then write the output
    function run() public {
        console.log("Generating Merkle Proof for %s", inputPath);

        for (uint256 i = 0; i < count; ++i) {
            string[] memory input = new string[](types.length); // both as strings values
            bytes32[] memory data = new bytes32[](types.length); // data as a bytes32

            for (uint256 j = 0; j < types.length; ++j) {
                if (compareStrings(types[j], "address")) {
                    address value = elements.readAddress(getValuesByIndex(i, j));
                    
                    // you cannot directly cast an Ethereum address (20 bytes) to a bytes32 type (32 bytes)
                    // you must first cast the address to uint160 (20 bytes), then to uint256 (32 bytes), and finally to bytes32 (32 bytes)
                    // this process ensures that the address is correctly and safely converted to the bytes32 type
                    data[j] = bytes32(uint256(uint160(value)));

                    input[j] = vm.toString(value);
                } else if (compareStrings(types[j], "uint")) {
                    uint256 value = vm.parseUint(elements.readString(getValuesByIndex(i, j)));
                    data[j] = bytes32(value);
                    input[j] = vm.toString(value);
                }
            }
            // Create the hash for the merkle tree leaf node
            // It involves ABI encoding the data array (address and amount), 
            // removing the offset and length using ltrim64, hashing the encoded data, 
            // converting the hash to bytes, and hashing again to prevent preimage attacks.
            leafs[i] = keccak256(bytes.concat(keccak256(ltrim64(abi.encode(data)))));

            // converts string array into a json array string
            inputs[i] = stringArrayToString(input);
        }

        for (uint256 i = 0; i < count; ++i) {
            // get proof gets the nodes needed for the proof
            string memory proof = bytes32ArrayToString(m.getProof(leafs, i));
            // get root hash
            string memory root = vm.toString(m.getRoot(leafs));
            // get the current leaf
            string memory leaf = vm.toString(leafs[i]);
            // get the input (address, amount)
            string memory input = inputs[i];

            // generate tree dump
            outputs[i] = generateOutputFile(input, proof, root, leaf);
        }

        // convert the string array into a json array string
        output = stringArrayToArrayString(outputs);
        // write the output to the output file
        vm.writeFile(string.concat(vm.projectRoot(), outputPath), output);

        console.log("Output created at %s", outputPath);
    }
}
