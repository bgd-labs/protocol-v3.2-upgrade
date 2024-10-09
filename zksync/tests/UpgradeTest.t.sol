// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {ProtocolV3TestBase, IPool} from 'aave-helpers/zksync/src/ProtocolV3TestBase.sol';
import {UpgradePayload} from '../../src/contracts/UpgradePayload.sol';

abstract contract UpgradeTest is ProtocolV3TestBase {
  string public NETWORK;
  uint256 public immutable BLOCK_NUMBER;
  UpgradePayload public payload;

  constructor(string memory network, uint256 blocknumber) {
    NETWORK = network;
    BLOCK_NUMBER = blocknumber;
  }

  function setUp() public override {
    vm.createSelectFork(vm.rpcUrl(NETWORK), BLOCK_NUMBER);
    payload = UpgradePayload(_getPayload());
    super.setUp();
  }

  function test_execution() external {
    executePayload(vm, address(payload));
  }

  function test_outdatedPdp() external {
    IPoolAddressesProvider addressesProvider = UpgradePayload(payload).POOL_ADDRESSES_PROVIDER();
    IPool pool = IPool(addressesProvider.getPool());
    address[] memory reserves = pool.getReservesList();
    for (uint256 i = 0; i < reserves.length; i++) {
      IPoolDataProvider pdp = IPoolDataProvider(_getDeprecatedPDP());
      vm.expectRevert();
      pdp.getReserveData(reserves[i]);
      vm.expectRevert();
      pdp.getTotalDebt(reserves[i]);
      vm.expectRevert();
      pdp.getUserReserveData(reserves[i], address(0));
    }
    executePayload(vm, address(payload));
    for (uint256 i = 0; i < reserves.length; i++) {
      IPoolDataProvider pdp = IPoolDataProvider(_getDeprecatedPDP());
      pdp.getReserveData(reserves[i]);
      pdp.getTotalDebt(reserves[i]);
      pdp.getUserReserveData(reserves[i], address(0));
    }
  }

  function test_deployed() external {
    UpgradePayload deployed = UpgradePayload(_getDeployedPayload());
    require(address(deployed) != address(0), 'PAYLOAD_NOT_YET_DEPLOYED');
    IPoolAddressesProvider addressesProvider = UpgradePayload(deployed).POOL_ADDRESSES_PROVIDER();
    IPool pool = IPool(addressesProvider.getPool());
    defaultTest(
      string(abi.encodePacked(vm.toString(block.chainid), '_', vm.toString(address(pool)))),
      pool,
      address(deployed)
    );
  }

  function _getPayload() internal virtual returns (address);

  function _getDeployedPayload() internal virtual returns (address) {
    return address(0);
  }
}
