// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";

/**
 * @title DeploySteaking.
 * @author mgnfy-view.
 * @notice This script can be used to deploy the `Steaking` contract on any chain. However, the correct
 * WETH address must be set before deployment.
 */
contract DeploySteaking is Script {
    string public constant PATH = "src/Steaking.vy";
    address public constant MAINNET_WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    function run() public returns (address steaking) {
        vm.startBroadcast();
        steaking = deployCode(PATH, abi.encode(MAINNET_WETH));
        vm.stopBroadcast();
    }
}
