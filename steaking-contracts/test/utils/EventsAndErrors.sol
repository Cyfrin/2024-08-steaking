// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

abstract contract EventsAndErrors {
    event Staked(address indexed by, uint256 indexed amount, address indexed onBehalfOf);
    event Unstaked(address indexed by, uint256 indexed amount, address to);
    event VaultAddressSet(address indexed vault);
    event DepositedIntoVault(address indexed by, uint256 indexed amount, uint256 indexed sharesReceived);

    // Error strings
    string public constant STEAK__STAKING_PERIOD_ENDED = "Steak__StakingPeriodEnded";
    string public constant STEAK__INSUFFICIENT_STAKE_AMOUNT = "Steak__InsufficientStakeAmount";
    string public constant STEAK__ADDRESS_ZERO = "Steak__AddressZero";
    string public constant STEAK__AMOUNT_ZERO = "Steak__AmountZero";
    string public constant STEAK__NOT_OWNER = "Steak__NotOwner";
    string public constant STEAK__CANNOT_SET_VAULT_ADDRESS_BEFORE_STAKING_PERIOD_ENDS =
        "Steak__CannotSetVaultAddressBeforeStakingPeriodEnds";
    string public constant STEAK__STAKING_PERIOD_NOT_ENDED_OR_VAULT_ADDRESS_NOT_SET =
        "Steak__StakingPeriodNotEndedOrVaultAddressNotSet";
}
