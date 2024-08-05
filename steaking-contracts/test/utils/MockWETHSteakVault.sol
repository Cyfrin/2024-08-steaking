// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC4626} from "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MockWETHSteakVault is ERC4626 {
    constructor(IERC20 _asset) ERC20("WETHSteakVault", "WETHSTK") ERC4626(_asset) {}
}
