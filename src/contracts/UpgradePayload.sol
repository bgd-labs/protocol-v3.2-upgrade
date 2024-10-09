// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {DataTypes} from 'aave-v3-origin/contracts/protocol/libraries/types/DataTypes.sol';
import {IPool} from 'aave-v3-origin/contracts/interfaces/IPool.sol';
import {IPoolAddressesProvider} from 'aave-v3-origin/contracts/interfaces/IPoolAddressesProvider.sol';
import {IPoolConfigurator} from 'aave-v3-origin/contracts/interfaces/IPoolConfigurator.sol';
import {EModeConfiguration} from 'aave-v3-origin/contracts/protocol/libraries/configuration/EModeConfiguration.sol';
import {DefaultReserveInterestRateStrategyV2} from 'aave-v3-origin/contracts/misc/DefaultReserveInterestRateStrategyV2.sol';
import {IDefaultInterestRateStrategyV2} from 'aave-v3-origin/contracts/interfaces/IDefaultInterestRateStrategyV2.sol';
import {ReserveConfiguration as ReserveConfigurationLegacy} from './lib/LegacyReserveConfiguration.sol';

contract UpgradePayload {
  using EModeConfiguration for DataTypes.EModeCategory;
  using ReserveConfigurationLegacy for DataTypes.ReserveConfigurationMap;

  struct ConstructorParams {
    IPoolAddressesProvider poolAddressesProvider;
    address poolImpl;
    address stableDebtToken;
  }

  IPoolAddressesProvider public immutable POOL_ADDRESSES_PROVIDER;
  address public immutable POOL_IMPL;
  address public immutable STABLE_DEBT_TOKEN;

  constructor(ConstructorParams memory params) {
    POOL_ADDRESSES_PROVIDER = params.poolAddressesProvider;
    POOL_IMPL = params.poolImpl;
    STABLE_DEBT_TOKEN = params.stableDebtToken;
  }

  function execute() external {
    POOL_ADDRESSES_PROVIDER.setPoolImpl(POOL_IMPL);
    POOL_ADDRESSES_PROVIDER.setAddress(bytes32('MOCK_STABLE_DEBT'), STABLE_DEBT_TOKEN);
  }
}
