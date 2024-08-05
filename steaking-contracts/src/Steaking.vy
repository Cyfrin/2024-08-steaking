# pragma version 0.4.0

"""
@title Steaking.
@license MIT.
@author mgnfy-view.
@notice The `Steaking` contract allows users to stake ETH and earn steak points on
an off-chain server. The staking period lasts for 4 weeks, and the goal is to aggregate
as much liquidity as possible to bootstrap the WETH Steak vault -- a yield farming vault,
core product of Steak. Once the vault address is set after the staking period ends, users
will be able to deposit their staked ETH into the WETH vault.
"""

from .interfaces import IWETHSteakVault
from .interfaces import IWETH

ADDRESS_ZERO: constant(address) = 0x0000000000000000000000000000000000000000
MIN_STAKE_AMOUNT: constant(uint256) = 500000000000000000 # 0.5 ether
STAKING_PERIOD: constant(uint256) = 2419200 # 4 weeks

WETH: public(immutable(address))

startTimestamp: uint256
owner: public(address)
usersToStakes: public(HashMap[address, uint256])
totalAmountStaked: public(uint256)
vault: public(address)

event Staked:
    by: indexed(address)
    amount: indexed(uint256)
    onBehalfOf: indexed(address)

event Unstaked:
    by: indexed(address)
    amount: indexed(uint256)
    to: address

event VaultAddressSet:
    vault: indexed(address)

event DepositedIntoVault:
    by: indexed(address)
    amount: indexed(uint256)
    sharesReceived: indexed(uint256)

STEAK__STAKING_PERIOD_ENDED: constant(String[25]) = "Steak__StakingPeriodEnded"
STEAK__INSUFFICIENT_STAKE_AMOUNT: constant(String[30]) = "Steak__InsufficientStakeAmount"
STEAK__ADDRESS_ZERO: constant(String[18]) = "Steak__AddressZero"
STEAK__AMOUNT_ZERO: constant(String[17]) = "Steak__AmountZero"
STEAK__NOT_OWNER: constant(String[15]) = "Steak__NotOwner"
STEAK__CANNOT_SET_VAULT_ADDRESS_BEFORE_STAKING_PERIOD_ENDS: constant(String[51]) = "Steak__CannotSetVaultAddressBeforeStakingPeriodEnds"
STEAK__STAKING_PERIOD_NOT_ENDED_OR_VAULT_ADDRESS_NOT_SET: constant(String[48]) = "Steak__StakingPeriodNotEndedOrVaultAddressNotSet"

@deploy
def __init__(_weth: address):
    WETH = _weth

    self.startTimestamp = block.timestamp
    self.owner = msg.sender

@external
@payable
def stake(_onBehalfOf: address):
    """
    @notice Allows users to stake ETH for themselves or any other user within the staking period.
    @param _onBehalfOf The address to stake on behalf of.
    """
    assert not self._hasStakingPeriodEnded(), STEAK__STAKING_PERIOD_ENDED
    assert msg.value >= MIN_STAKE_AMOUNT, STEAK__INSUFFICIENT_STAKE_AMOUNT
    assert _onBehalfOf != ADDRESS_ZERO, STEAK__ADDRESS_ZERO

    self.usersToStakes[_onBehalfOf] = msg.value
    self.totalAmountStaked += msg.value

    log Staked(msg.sender, msg.value, _onBehalfOf)

@external
def unstake(_amount: uint256, _to: address):
    """
    @notice Allows users to unstake their staked ETH before the staking period ends. Users
    can adjust their staking amounts to their liking.
    @param _amount The amount of staked ETH to withdraw.
    @param _to The address to send the withdrawn ETH to. 
    """
    assert not self._hasStakingPeriodEnded(), STEAK__STAKING_PERIOD_ENDED
    assert _to != ADDRESS_ZERO, STEAK__ADDRESS_ZERO

    stakedAmount: uint256 = self.usersToStakes[msg.sender]
    assert stakedAmount > 0 and _amount > 0, STEAK__AMOUNT_ZERO
    assert _amount <= stakedAmount, STEAK__INSUFFICIENT_STAKE_AMOUNT

    self.usersToStakes[msg.sender] -= _amount
    self.totalAmountStaked -= _amount

    send(_to, _amount)

    log Unstaked(msg.sender, _amount, _to)

@external
def setVaultAddress(_vault: address):
    """
    @notice Allows the owner of this contract to set the WETH Steak vault address after the staking
    period has ended.
    @param _vault The address of the WETH Steak vault.
    """
    assert msg.sender == self.owner, STEAK__NOT_OWNER
    assert self._hasStakingPeriodEnded(), STEAK__CANNOT_SET_VAULT_ADDRESS_BEFORE_STAKING_PERIOD_ENDS
    assert _vault != ADDRESS_ZERO, STEAK__ADDRESS_ZERO

    self.vault = _vault

    log VaultAddressSet(_vault)

@external
def depositIntoVault() -> uint256:
    """
    @notice Allows users who have staked ETH during the staking period to deposit their ETH
    into the WETH Steak vault.
    @dev Before depositing into the vault, the raw ETH is converted into WETH.
    @return The amount of shares received from the WETH Steak vault.
    """
    assert self._hasStakingPeriodEndedAndVaultAddressSet(), STEAK__STAKING_PERIOD_NOT_ENDED_OR_VAULT_ADDRESS_NOT_SET
    stakedAmount: uint256 = self.usersToStakes[msg.sender]
    assert stakedAmount > 0, STEAK__AMOUNT_ZERO

    extcall IWETH(WETH).deposit(value=stakedAmount)
    extcall IWETH(WETH).approve(self.vault, stakedAmount)
    sharesReceived: uint256 = extcall IWETHSteakVault(self.vault).deposit(stakedAmount, msg.sender)

    log DepositedIntoVault(msg.sender, stakedAmount, sharesReceived)

    return sharesReceived

@internal
@view
def _hasStakingPeriodEnded() -> bool:
    return block.timestamp > self.startTimestamp + STAKING_PERIOD

@internal
@view
def _hasStakingPeriodEndedAndVaultAddressSet() -> bool:
    return self._hasStakingPeriodEnded() and self.vault != ADDRESS_ZERO

@external
@view
def getMinimumStakingAmount() -> uint256:
    """
    @notice Gets the minimum staking amount (0.5 ether).
    @return The minimum staking amount.
    """
    return MIN_STAKE_AMOUNT

@external
@view
def hasStakingPeriodEnded() -> bool:
    """
    @notice Checks if the staking period has ended or not.
    @return True if the staking period has ended, false otherwise.
    """
    return self._hasStakingPeriodEnded()