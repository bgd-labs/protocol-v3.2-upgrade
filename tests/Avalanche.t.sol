// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {UpgradeTest} from './UpgradeTest.t.sol';
import {DeploymentLibrary} from '../scripts/Deploy.s.sol';
import {Payloads} from './Payloads.sol';

contract AvalancheTest is UpgradeTest('avalanche', 51554357) {
  function _getPayload() internal virtual override returns (address) {
    return DeploymentLibrary._deployAvalanche();
  }

  function _getDeployedPayload() internal virtual override returns (address) {
    return Payloads.AVALANCHE;
  }

  function _getDeprecatedPDP() internal virtual override returns (address) {
    return address(0x7deEB8aCE4220643D8edeC871a23807E4d006eE5);
  }
}
