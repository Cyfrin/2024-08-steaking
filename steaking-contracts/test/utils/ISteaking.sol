// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

interface ISteaking {
    function WETH() external view returns (address);

    function owner() external view returns (address);

    function usersToStakes(address _user) external view returns (uint256);

    function totalAmountStaked() external view returns (uint256);

    function vault() external view returns (address);

    function stake(address _onBehalfOf) external payable;

    function unstake(uint256 _amount, address _to) external;

    function setVaultAddress(address _vault) external;

    function depositIntoVault() external returns (uint256);

    function getMinimumStakingAmount() external view returns (uint256);

    function hasStakingPeriodEnded() external view returns (bool);
}
