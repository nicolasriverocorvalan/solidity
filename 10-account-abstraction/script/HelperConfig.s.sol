// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {

    error HelperConfig__InvalidChainId();

    struct NetworkConfig {
        address entryPoint;
        address account;
    }

    uint256 constant LOCAL_CHAIN_ID = 31337;
    uint256 constant ETH_SEPOLIA_CHAIN_ID = 11155111;
    uint256 constant ZKSYNC_SEPOLIA_CHAIN_ID= 300;
    address constant BURNER_WALLET = 0x64Dd9D94818A2CA2e95c31B084aeF0CC92e86dA2; //my wallet

    NetworkConfig public localNetworkConfig;
    mapping(uint256 chainId => NetworkConfig) public NetworkConfigs;

    constructor(){
        NetworkConfigs[ETH_SEPOLIA_CHAIN_ID] = getEthSepoliaConfig(); 
    }

    function getConfig() public view returns (NetworkConfig memory) {
        return getConfigByChainId(block.chainid);
    }

    function getConfigByChainId(uint256 chainId) public view returns (NetworkConfig memory) {
        if(chainId == LOCAL_CHAIN_ID){
            return getOrCreateAnvilEthConfig();
        } else if(NetworkConfigs[chainId].account != address(0)) {
            return NetworkConfigs[chainId];
        } else {
            revert HelperConfig__InvalidChainId();
        }
    }

    function getEthSepoliaConfig() public pure returns (NetworkConfig memory) {
        // https://sepolia.etherscan.io/address/0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789
        return NetworkConfig({entryPoint: 0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789, account: BURNER_WALLET});
    }

    function getZkSyncSepoliaConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({entryPoint: address(0), account: BURNER_WALLET});
    }

    function getOrCreateAnvilEthConfig() public view returns (NetworkConfig memory) {
        if(localNetworkConfig.account != address(0)){
            return localNetworkConfig;
        }

        return localNetworkConfig;
    }
}
