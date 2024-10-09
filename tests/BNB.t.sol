// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {UpgradeTest} from './UpgradeTest.t.sol';
import {DeploymentLibrary} from '../scripts/Deploy.s.sol';
import {Payloads} from './Payloads.sol';

contract BNBTest is UpgradeTest('bnb', 42961933) {
  function _getPayload() internal virtual override returns (address) {
    return DeploymentLibrary._deployBNB();
  }

  function _getDeployedPayload() internal virtual override returns (address) {
    return Payloads.BNB;
  }

  function _getDeprecatedPDP() internal virtual override returns (address) {
    return address(0x6736393C50A4B1bd402d97aa5b979d396e5d8d4B);
  }
}
