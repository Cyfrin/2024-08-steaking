// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {Test} from "forge-std/Test.sol";

import {ISteaking} from "./utils/ISteaking.sol";

import {EventsAndErrors} from "./utils/EventsAndErrors.sol";
import {MockWETH} from "./utils/MockWETH.sol";
import {MockWETHSteakVault} from "./utils/MockWETHSteakVault.sol";

contract SteakingTest is Test, EventsAndErrors {
    address public owner;
    address public user1;

    ISteaking public steaking;
    MockWETH public weth;
    MockWETHSteakVault public wethSteakVault;

    function setUp() public {
        string memory path = "src/Steaking.vy";

        owner = makeAddr("owner");
        user1 = makeAddr("user1");

        vm.startPrank(owner);
        weth = new MockWETH();
        steaking = ISteaking(deployCode(path, abi.encode(address(weth))));
        wethSteakVault = new MockWETHSteakVault(IERC20(address(weth)));
        vm.stopPrank();
    }

    function testInitialization() public view {
        address mockWeth = steaking.WETH();
        address actualOwner = steaking.owner();
        uint256 totalAmountStaked = steaking.totalAmountStaked();
        address vault = steaking.vault();

        assertEq(mockWeth, address(weth));
        assertEq(actualOwner, owner);
        assertEq(totalAmountStaked, uint256(0));
        assertEq(vault, address(0));
    }

    function testGetMinimumStakingAmount() public view {
        uint256 expectedMinimumStakingAmount = 0.5 ether;
        uint256 actualMinimumStakingAmount = steaking.getMinimumStakingAmount();

        assertEq(actualMinimumStakingAmount, expectedMinimumStakingAmount);
    }

    function testStakingPeriodHasNotEnded() public view {
        bool hasStakingPeriodEnded = steaking.hasStakingPeriodEnded();
        bool expectedBool = false;

        assertEq(hasStakingPeriodEnded, expectedBool);
    }

    function testStakingPeriodHasEnded() public {
        bool expectedBool = true;

        _endStakingPeriod();

        bool hasStakingPeriodEnded = steaking.hasStakingPeriodEnded();

        assertEq(hasStakingPeriodEnded, expectedBool);
    }

    function testStake() public {
        uint256 dealAmount = steaking.getMinimumStakingAmount();
        _stake(user1, dealAmount, user1);

        uint256 userStakedAmount = steaking.usersToStakes(user1);
        uint256 totalAmountStaked = steaking.totalAmountStaked();

        assertEq(userStakedAmount, dealAmount);
        assertEq(totalAmountStaked, dealAmount);
    }

    function testStakingFailsAfterStakingPeriodHasEnded() public {
        uint256 dealAmount = steaking.getMinimumStakingAmount();
        _endStakingPeriod();

        vm.expectRevert(bytes(STEAK__STAKING_PERIOD_ENDED));
        _stake(user1, dealAmount, user1);
    }

    function testStakingFailsForLessThanMinimumAmountStaked() public {
        uint256 smallDealAmount = steaking.getMinimumStakingAmount() - 1;

        vm.expectRevert(bytes(STEAK__INSUFFICIENT_STAKE_AMOUNT));
        _stake(user1, smallDealAmount, user1);
    }

    function testStakingFailsForAddressZero() public {
        uint256 dealAmount = steaking.getMinimumStakingAmount();

        vm.expectRevert(bytes(STEAK__ADDRESS_ZERO));
        _stake(user1, dealAmount, address(0));
    }

    function testStakingEmitsEvent() public {
        uint256 dealAmount = steaking.getMinimumStakingAmount();

        vm.expectEmit(true, true, true, false);
        emit Staked(user1, dealAmount, user1);
        _stake(user1, dealAmount, user1);
    }

    function testUnstake() public {
        // Let's deposit a large amount and withdraw half of it
        uint256 dealAmount = 1 ether;
        _stake(user1, dealAmount, user1);

        uint256 user1BalanceBefore = user1.balance;
        uint256 amountToUnstake = dealAmount / 2;

        _unstake(user1, amountToUnstake, user1);

        uint256 user1BalanceAfter = user1.balance;
        uint256 expectedUserBalanceAfter = dealAmount - amountToUnstake;

        uint256 totalAmountStaked = steaking.totalAmountStaked();
        uint256 user1StakedAmount = steaking.usersToStakes(user1);

        assertEq(user1BalanceAfter - user1BalanceBefore, expectedUserBalanceAfter);
        assertEq(totalAmountStaked, dealAmount - amountToUnstake);
        assertEq(user1StakedAmount, dealAmount - amountToUnstake);
    }

    function testUnstakingFailsAfterStakingPeriodHasEnded() public {
        uint256 dealAmount = 1 ether;
        _stake(user1, dealAmount, user1);

        _endStakingPeriod();

        uint256 amountToUnstake = dealAmount / 2;

        vm.expectRevert(bytes(STEAK__STAKING_PERIOD_ENDED));
        _unstake(user1, amountToUnstake, user1);
    }

    function testUnstakingFailsForAddressZero() public {
        uint256 dealAmount = 1 ether;
        _stake(user1, dealAmount, user1);

        uint256 amountToUnstake = dealAmount / 2;

        vm.expectRevert(bytes(STEAK__ADDRESS_ZERO));
        _unstake(user1, amountToUnstake, address(0));
    }

    function testUnstakingFailsForAmountToUnstakeLargerThanStakedAmount() public {
        uint256 dealAmount = 1 ether;
        _stake(user1, dealAmount, user1);

        uint256 amountToUnstake = dealAmount * 2;

        vm.expectRevert(bytes(STEAK__INSUFFICIENT_STAKE_AMOUNT));
        _unstake(user1, amountToUnstake, user1);
    }

    function testUnstakingEmitsEvent() public {
        uint256 dealAmount = 1 ether;
        _stake(user1, dealAmount, user1);

        uint256 amountToUnstake = dealAmount / 2;

        vm.expectEmit(true, true, true, false);
        emit Unstaked(user1, amountToUnstake, user1);
        _unstake(user1, amountToUnstake, user1);
    }

    function testSetVaultAddress() public {
        _endStakingPeriod();

        vm.startPrank(owner);
        steaking.setVaultAddress(address(wethSteakVault));
        vm.stopPrank();
    }

    function testSetVaultAddressFailsAccessControlIssue() public {
        _endStakingPeriod();

        vm.startPrank(user1);
        vm.expectRevert(bytes(STEAK__NOT_OWNER));
        steaking.setVaultAddress(address(wethSteakVault));
        vm.stopPrank();
    }

    function testSetVaultAddressFailsBeforeStakingPeriodHasEnded() public {
        vm.startPrank(owner);
        vm.expectRevert(bytes(STEAK__CANNOT_SET_VAULT_ADDRESS_BEFORE_STAKING_PERIOD_ENDS));
        steaking.setVaultAddress(address(wethSteakVault));
        vm.stopPrank();
    }

    function testSetVaultAddressFailsIfVaultAddressZero() public {
        _endStakingPeriod();

        vm.startPrank(owner);
        vm.expectRevert(bytes(STEAK__ADDRESS_ZERO));
        steaking.setVaultAddress(address(0));
        vm.stopPrank();
    }

    function testSetVaultAddressEmitsEvent() public {
        _endStakingPeriod();

        vm.startPrank(owner);
        vm.expectEmit(true, false, false, false);
        emit VaultAddressSet(address(wethSteakVault));
        steaking.setVaultAddress(address(wethSteakVault));
        vm.stopPrank();
    }

    function testDepositIntoVault() public {
        uint256 dealAmount = steaking.getMinimumStakingAmount();
        _startVaultDepositPhase(user1, dealAmount, user1);

        vm.startPrank(user1);
        steaking.depositIntoVault();
        vm.stopPrank();

        uint256 steakingBalance = address(steaking).balance;
        uint256 expectedSteakingBalance = 0;
        uint256 wethSteakVaultShares = wethSteakVault.balanceOf(user1);

        assertEq(steakingBalance, expectedSteakingBalance);
        assertEq(wethSteakVaultShares, dealAmount);
    }

    function testDepositIntoVaultFailBeforeStakingPeriodEnds() public {
        uint256 dealAmount = steaking.getMinimumStakingAmount();
        _stake(user1, dealAmount, user1);

        vm.startPrank(user1);
        vm.expectRevert(bytes(STEAK__STAKING_PERIOD_NOT_ENDED_OR_VAULT_ADDRESS_NOT_SET));
        steaking.depositIntoVault();
        vm.stopPrank();
    }

    function testDepositIntoVaultFailsIfVaultAddressNotSet() public {
        uint256 dealAmount = steaking.getMinimumStakingAmount();
        _stake(user1, dealAmount, user1);
        _endStakingPeriod();

        vm.startPrank(user1);
        vm.expectRevert(bytes(STEAK__STAKING_PERIOD_NOT_ENDED_OR_VAULT_ADDRESS_NOT_SET));
        steaking.depositIntoVault();
        vm.stopPrank();
    }

    function testDepositIntoVaultFailsIfStakedAmountIsZero() public {
        _endStakingPeriod();

        vm.startPrank(owner);
        steaking.setVaultAddress(address(wethSteakVault));
        vm.stopPrank();

        vm.startPrank(user1);
        vm.expectRevert(bytes(STEAK__AMOUNT_ZERO));
        steaking.depositIntoVault();
        vm.stopPrank();
    }

    function testDepositIntoVaultEmitsEvent() public {
        uint256 dealAmount = steaking.getMinimumStakingAmount();
        _startVaultDepositPhase(user1, dealAmount, user1);

        vm.startPrank(user1);
        vm.expectEmit(true, true, true, false);
        emit DepositedIntoVault(user1, dealAmount, dealAmount);
        steaking.depositIntoVault();
        vm.stopPrank();
    }

    function _stake(address _user, uint256 _amount, address _onBehlafOf) internal {
        vm.deal(_user, _amount);

        vm.startPrank(_user);
        steaking.stake{value: _amount}(_onBehlafOf);
        vm.stopPrank();
    }

    function _unstake(address _user, uint256 _amount, address _to) internal {
        vm.startPrank(_user);
        steaking.unstake(_amount, _to);
        vm.stopPrank();
    }

    function _endStakingPeriod() internal {
        uint256 warpBy = 4 weeks + 1;
        vm.warp(block.timestamp + warpBy);
    }

    function _startVaultDepositPhase(address _user, uint256 _amount, address _onBehlafOf) internal {
        _stake(_user, _amount, _onBehlafOf);
        _endStakingPeriod();

        vm.startPrank(owner);
        steaking.setVaultAddress(address(wethSteakVault));
        vm.stopPrank();
    }
}
